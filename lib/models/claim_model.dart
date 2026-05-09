class ClaimModel {
  final String claim;
  final String status;
  final String correctedFact;
  final String source;

  ClaimModel({
    required this.claim,
    required this.status,
    required this.correctedFact,
    required this.source,
  });

  factory ClaimModel.fromJson(Map<String, dynamic> json) {
    return ClaimModel(
      claim: json['claim'] ?? '',
      status: json['status'] ?? '',
      correctedFact: json['correctedFact'] ?? '',
      source: json['source'] ?? '',
    );
  }
}