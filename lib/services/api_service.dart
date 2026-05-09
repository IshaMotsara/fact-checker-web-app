import 'dart:convert';
import 'dart:typed_data';


import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../models/claim_model.dart';

class ApiService {
  /// Set at build/run time: `--dart-define=GEMINI_API_KEY=...`
  /// Optional: `--dart-define=GEMINI_MODEL=gemini-2.0-flash` (etc.)
  static const String _apiKey =
      String.fromEnvironment('GEMINI_API_KEY');
  static const String _model = String.fromEnvironment(
    'GEMINI_MODEL',
    defaultValue: 'gemini-2.5-flash-lite',
  );

  Future<List<ClaimModel>> analyzePdf(
      Uint8List pdfBytes) async {
    if (_apiKey.isEmpty) {
      throw Exception(
        'GEMINI_API_KEY is missing (it must be baked in at build/start time). '
        'Either: (1) Copy secrets.json.example to secrets.json, put your key in '
        'that JSON file, stop the app completely, then start with the Cursor/VS '
        'Code launch config "fact_checker (Chrome + secrets)"; or (2) run '
        '`flutter run -d chrome --dart-define-from-file=secrets.json` after '
        'creating secrets.json. Keys: https://aistudio.google.com/apikey ',
      );
    }

    /// STEP 1: Extract text from PDF
    final PdfDocument document =
        PdfDocument(inputBytes: pdfBytes);

    final String extractedText =
        PdfTextExtractor(document).extractText();

    document.dispose();

    /// Prefer lines that look claim-like (have a digit); if that strips everything
    /// (scanned PDF, short doc), fall back to full extract (trimmed length cap).
    const maxChars = 24000;
    final claimLines = extractedText
        .split('\n')
        .where((line) => RegExp('[0-9]').hasMatch(line))
        .join('\n')
        .trim();
    var textForModel = claimLines.isNotEmpty
        ? (claimLines.length > maxChars
            ? claimLines.substring(0, maxChars)
            : claimLines)
        : extractedText.trim();
    if (textForModel.length > maxChars) {
      textForModel = textForModel.substring(0, maxChars);
    }
    if (textForModel.isEmpty) {
      throw Exception(
        'Could not read any text from this PDF (it may be image-only '
        'or protected). Try a PDF with selectable text.',
      );
    }

    /// STEP 2: Send to Gemini API
    final response = await http.post(

      
        Uri.parse(
          'https://generativelanguage.googleapis.com/v1beta/models/$_model:generateContent?key=$_apiKey',
        ),
      

      headers: {
        'Content-Type': 'application/json',
      },

      body: jsonEncode({

        "contents": [
          {
            "parts": [
              {
                "text": """
You are a professional fact-checking system. Analyze the excerpt below.

Rules:
- Output MUST be ONLY a JSON array (no prose, markdown, code fences, or explanations).
- If there are zero clear factual claims, return [].
- status must be one of: Verified, Inaccurate, False.

Extract factual claims such as statistics, dates, percentages, finance/technical claims.

For each claim use exactly these keys: claim, status, correctedFact, source.

PDF TEXT:
$textForModel
"""
              }
            ]
          }
        ],

        "generationConfig": {
          "temperature": 0.2,
          "responseMimeType": "application/json",
          "responseSchema": {
            "type": "ARRAY",
            "items": {
              "type": "OBJECT",
              "properties": {
                "claim": {"type": "STRING"},
                "status": {"type": "STRING"},
                "correctedFact": {"type": "STRING"},
                "source": {"type": "STRING"},
              },
              "required": [
                "claim",
                "status",
                "correctedFact",
                "source",
              ],
            },
          },
        }

      }),
    );

    /// STEP 3: Handle response
    if (response.statusCode == 200) {

      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      final candidates = decoded['candidates'];
      if (candidates is! List || candidates.isEmpty) {
        throw Exception(
          'No model output (blocked or empty). ${decoded['promptFeedback'] ?? ''}',
        );
      }
      final first = candidates[0] as Map<String, dynamic>?;
      final content = first?['content'] as Map<String, dynamic>?;
      final parts = content?['parts'] as List<dynamic>?;
      if (parts == null || parts.isEmpty) {
        throw Exception('Model returned no text parts.');
      }
      final text = (parts[0] as Map<String, dynamic>)['text'] as String?;

      final jsonData = _parseClaimsJsonArray(text ?? '');

      return jsonData
          .map((e) => ClaimModel.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();

    }

    return _failureFromHttpResponse(response);
  }

  /// Parses model text into a JSON array of claim objects; tolerates stray fences.
  List<dynamic> _parseClaimsJsonArray(String raw) {
    var s = raw
        .replaceAll('```json', '')
        .replaceAll('```', '')
        .trim();
    Object? decoded;
    try {
      decoded = jsonDecode(s);
    } catch (_) {
      final start = s.indexOf('[');
      final end = s.lastIndexOf(']');
      if (start >= 0 && end > start) {
        try {
          decoded = jsonDecode(s.substring(start, end + 1));
        } catch (_) {
          decoded = null;
        }
      }
    }
    if (decoded is List) return decoded;
    final preview = s.length > 160 ? '${s.substring(0, 160)}…' : s;
    throw Exception(
      'Model did not return a JSON array of claims. Start of reply: $preview',
    );
  }

  Never _failureFromHttpResponse(http.Response response) {
    if (response.statusCode == 429) {
      throw Exception(
        'Gemini quota or rate limit (429). Wait and retry, or open '
        'https://aistudio.google.com/ for quotas and billing. '
        'Try another model via secrets.json (e.g. GEMINI_MODEL=gemini-2.5-flash-lite) '
        'or check https://ai.google.dev/gemini-api/docs/models ',
      );
    }

    Object? decoded;
    try {
      decoded = jsonDecode(response.body);
    } catch (_) {
      throw Exception(
        'Failed to analyze PDF (${response.statusCode}). ${response.body}',
      );
    }

    final err = decoded is Map ? decoded['error'] : null;
    if (err is Map) {
      final msg = err['message']?.toString() ?? '';
      if (response.statusCode == 403 ||
          msg.contains('RESOURCE_EXHAUSTED') ||
          msg.contains('quota')) {
        throw Exception(
          'Gemini API rejected the request (${response.statusCode}). '
          'Often this is quota/billing — see Google AI Studio. $msg',
        );
      }
      throw Exception('Gemini API error: $msg');
    }

    throw Exception(
      'Failed to analyze PDF (${response.statusCode}). ${response.body}',
    );
  }
}