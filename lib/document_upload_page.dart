import 'package:flutter/material.dart';

class DocumentUploadPage extends StatefulWidget {
  final List<String> requiredDocs;
  
  const DocumentUploadPage({Key? key, required this.requiredDocs}) : super(key: key);

  @override
  State<DocumentUploadPage> createState() => _DocumentUploadPageState();
}

class _DocumentUploadPageState extends State<DocumentUploadPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Documents'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Required Documents for Upload:',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: widget.requiredDocs.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(widget.requiredDocs[index]),
                      trailing: const Icon(Icons.upload_file),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement document upload functionality
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Upload functionality coming soon!')),
                );
              },
              child: const Text('Upload Documents'),
            ),
          ],
        ),
      ),
    );
  }
} 