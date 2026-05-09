import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/claim_model.dart';

class ResultTile extends StatelessWidget {

  final ClaimModel claim;

  const ResultTile({
    super.key,
    required this.claim,
  });

  Color getStatusColor() {
    switch (claim.status.toLowerCase()) {
      case 'verified':
        return Colors.green;
        case 'inaccurate':
        return Colors.orange;

      case 'false':
        return Colors.red;

      default:
        return Colors.grey;
    }
  }

  Future<void> launchSource() async {

    final uri = Uri.parse(claim.source);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
   @override
  Widget build(BuildContext context) {

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            children: [

              Expanded(
                child: Text(
                  claim.claim,
                   style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: getStatusColor(),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(claim.status),
              )
            ],
          ),
          const SizedBox(height: 8),

          Text(
            claim.correctedFact,
            style: const TextStyle(
              color: Colors.white70,
            ),
          ),

          const SizedBox(height: 20),

          InkWell(
            onTap: launchSource,
            child: const Text(
              'Open Source',
              style: TextStyle(
                color: Colors.lightBlueAccent,
                decoration: TextDecoration.underline,
              ),
               ),
          )
        ],
      ),
    );
  }
}