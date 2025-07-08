import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'document_upload_service.dart';
import 'document_viewer_page.dart';

class DocumentManagementPage extends StatefulWidget {
  const DocumentManagementPage({Key? key}) : super(key: key);

  @override
  State<DocumentManagementPage> createState() => _DocumentManagementPageState();
}

class _DocumentManagementPageState extends State<DocumentManagementPage> {
  List<Map<String, dynamic>> allDocuments = [];
  bool isLoading = true;
  String? selectedLoanType;
  String? selectedDocumentType;

  @override
  void initState() {
    super.initState();
    _loadDocuments();
  }

  Future<void> _loadDocuments() async {
    setState(() => isLoading = true);
    try {
      final documents = await DocumentUploadService.getAllUserDocuments();
      setState(() {
        allDocuments = documents;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading documents: $e')),
      );
    }
  }

  List<Map<String, dynamic>> get filteredDocuments {
    return allDocuments.where((doc) {
      if (selectedLoanType != null && doc['loanType'] != selectedLoanType) {
        return false;
      }
      if (selectedDocumentType != null && doc['documentName'] != selectedDocumentType) {
        return false;
      }
      return true;
    }).toList();
  }

  List<String> get uniqueLoanTypes {
    return allDocuments.map((doc) => doc['loanType'] as String).toSet().toList()..sort();
  }

  List<String> get uniqueDocumentTypes {
    return allDocuments.map((doc) => doc['documentName'] as String).toSet().toList()..sort();
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  String _formatDate(Timestamp? timestamp) {
    if (timestamp == null) return 'Unknown';
    final date = timestamp.toDate();
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Document Management'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadDocuments,
          ),
        ],
      ),
      body: Column(
        children: [
          // Filters
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[100],
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedLoanType,
                    decoration: const InputDecoration(
                      labelText: 'Filter by Loan Type',
                      border: OutlineInputBorder(),
                    ),
                    items: [
                      const DropdownMenuItem(value: null, child: Text('All Loan Types')),
                      ...uniqueLoanTypes.map((type) => DropdownMenuItem(
                        value: type,
                        child: Text(type),
                      )),
                    ],
                    onChanged: (value) {
                      setState(() => selectedLoanType = value);
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedDocumentType,
                    decoration: const InputDecoration(
                      labelText: 'Filter by Document Type',
                      border: OutlineInputBorder(),
                    ),
                    items: [
                      const DropdownMenuItem(value: null, child: Text('All Documents')),
                      ...uniqueDocumentTypes.map((type) => DropdownMenuItem(
                        value: type,
                        child: Text(type),
                      )),
                    ],
                    onChanged: (value) {
                      setState(() => selectedDocumentType = value);
                    },
                  ),
                ),
              ],
            ),
          ),
          
          // Documents List
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredDocuments.isEmpty
                    ? const Center(
                        child: Text(
                          'No documents found',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: filteredDocuments.length,
                        itemBuilder: (context, index) {
                          final doc = filteredDocuments[index];
                          final docData = doc['documentData'] as Map<String, dynamic>;
                          
                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.deepPurple,
                                child: Icon(
                                  _getDocumentIcon(docData['fileExtension']),
                                  color: Colors.white,
                                ),
                              ),
                              title: Text(
                                doc['documentName'],
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Loan: ${doc['loanType']}'),
                                  Text('File: ${docData['originalFileName']}'),
                                  Text('Size: ${_formatFileSize(docData['fileSize'] ?? 0)}'),
                                  Text('Uploaded: ${_formatDate(docData['uploadedAt'])}'),
                                ],
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.visibility, color: Colors.blue),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DocumentViewerPage(
                                        documentUrl: docData['url'],
                                        documentName: doc['documentName'],
                                      ),
                                    ),
                                  );
                                },
                              ),
                              isThreeLine: true,
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  IconData _getDocumentIcon(String? extension) {
    switch (extension?.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'jpg':
      case 'jpeg':
      case 'png':
        return Icons.image;
      case 'doc':
      case 'docx':
        return Icons.description;
      default:
        return Icons.insert_drive_file;
    }
  }
} 