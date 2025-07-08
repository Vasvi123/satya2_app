import 'package:flutter/material.dart';
import 'document_upload_service.dart';
import 'document_viewer_page.dart';

class DocumentUploadPage extends StatefulWidget {
  final List<String> requiredDocs;
  final String loanType;
  
  const DocumentUploadPage({
    super.key, 
    required this.requiredDocs,
    required this.loanType,
  });

  @override
  State<DocumentUploadPage> createState() => _DocumentUploadPageState();
}

class _DocumentUploadPageState extends State<DocumentUploadPage> {
  final Map<String, String> uploadedDocuments = {};
  final Map<String, bool> isLoading = {};
  String? currentLoanId;

  Future<void> _uploadDocument(String docName) async {
    setState(() => isLoading[docName] = true);
    
    try {
      final fileUrl = await DocumentUploadService.uploadDocument(
        loanType: widget.loanType,
        docName: docName,
        loanId: currentLoanId,
      );
      
      if (fileUrl != null) {
        setState(() {
          uploadedDocuments[docName] = fileUrl;
          currentLoanId ??= DateTime.now().millisecondsSinceEpoch.toString();
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$docName uploaded successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error uploading $docName: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => isLoading[docName] = false);
    }
  }

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
              'Required Documents for ${widget.loanType}:',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: widget.requiredDocs.length,
                itemBuilder: (context, index) {
                  final docName = widget.requiredDocs[index];
                  final isUploaded = uploadedDocuments.containsKey(docName);
                  
                  return Card(
                    child: ListTile(
                      leading: Icon(
                        isUploaded ? Icons.check_circle : Icons.upload_file,
                        color: isUploaded ? Colors.green : Colors.grey,
                      ),
                      title: Text(docName),
                      subtitle: isUploaded 
                        ? const Text('Uploaded successfully', style: TextStyle(color: Colors.green))
                        : null,
                      trailing: isLoading[docName] == true
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : IconButton(
                            icon: Icon(
                              isUploaded ? Icons.visibility : Icons.upload_file,
                              color: isUploaded ? Colors.blue : Colors.deepPurple,
                            ),
                            onPressed: isLoading[docName] == true ? null : () {
                              if (isUploaded) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DocumentViewerPage(
                                      documentUrl: uploadedDocuments[docName]!,
                                      documentName: docName,
                                    ),
                                  ),
                                );
                              } else {
                                _uploadDocument(docName);
                              }
                            },
                          ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: uploadedDocuments.length == widget.requiredDocs.length || isLoading.values.any((v) => v == true)
                ? () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('All documents uploaded successfully!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                    Navigator.of(context).pop();
                  }
                : null,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.deepPurple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                uploadedDocuments.length == widget.requiredDocs.length
                  ? 'Complete Upload'
                  : 'Upload ${widget.requiredDocs.length - uploadedDocuments.length} more documents',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 