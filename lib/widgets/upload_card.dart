import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class UploadCard extends StatelessWidget {

  final VoidCallback onTap;
  final bool isUploaded;

  const UploadCard({
    super.key,
    required this.onTap,
    required this.isUploaded,
  });

  @override
  Widget build(BuildContext context) {

    return InkWell(
      onTap: onTap,
      child: DottedBorder(
        borderType: BorderType.RRect,
        radius: const Radius.circular(20),
        color: Colors.blue,
        strokeWidth: 2,
        dashPattern: const [8, 4],
        child: Container(
          width: 500,
          height: 250,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white.withOpacity(0.04),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Icon(
                isUploaded
                    ? Icons.check_circle
                    : Icons.upload_file,
                size: 80,
                color: isUploaded
                    ? Colors.green
                    : Colors.white,
              ),

              const SizedBox(height: 20),

              Text(
                isUploaded
                    ? 'PDF Uploaded Successfully'
                    : 'Upload PDF',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                'Click to select a PDF file',
                 style: TextStyle(
                  color: Colors.grey,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}