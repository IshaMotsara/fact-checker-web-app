import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../models/claim_model.dart';
import '../services/api_service.dart';
import '../widgets/upload_card.dart';
import 'result_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
Uint8List? pdfBytes;

  bool isLoading = false;

  final ApiService apiService = ApiService();

  Future<void> pickPdf() async {

    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      withData: true,
    );

    if (result != null) {
      setState(() {
        pdfBytes = result.files.first.bytes;
      });
    }
  }
  Future<void> analyzePdf() async {

    if (pdfBytes == null) return;

    setState(() {
      isLoading = true;
    });

    try {

      final List<ClaimModel> results =
          await apiService.analyzePdf(pdfBytes!);

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ResultScreen(results: results),
        ),
      );
      } catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );

    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [

                const Text(
                  'Truth Layer',
                  style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),
                const Text(
                  'AI Powered Fact Checking Web App',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 40),

                UploadCard(
                  onTap: pickPdf,
                  isUploaded: pdfBytes != null,
                ),

                const SizedBox(height: 30),
                isLoading
                    ? const SpinKitThreeBounce(
                        color: Colors.white,
                        size: 28,
                      )
                    : ElevatedButton(
                        onPressed: analyzePdf,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 18,
                          ),
                        ),
                        child: const Text(
                          'Analyze PDF',
                          style: TextStyle(fontSize: 18),
                        ),
                          )
              ],
            ),
          ),
        ),
      ),
    );
  }
}