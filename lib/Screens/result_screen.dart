import 'package:flutter/material.dart';

import '../models/claim_model.dart';
import '../widgets/result_tile.dart';

class ResultScreen extends StatelessWidget {

  final List<ClaimModel> results;

  const ResultScreen({
    super.key,
    required this.results,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(
    appBar: AppBar(
        title: const Text('Verification Report'),
      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: results.length,
        itemBuilder: (context, index) {
          return ResultTile(claim: results[index]);
        },
      ),
    );
  }
}