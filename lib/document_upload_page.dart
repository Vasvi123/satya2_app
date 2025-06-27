import 'package:flutter/material.dart';

class DocumentUploadPage extends StatefulWidget {
  final List<String> requiredDocs;
  const DocumentUploadPage({Key? key, required this.requiredDocs}) : super(key: key);

  @override
  State<DocumentUploadPage> createState() => _DocumentUploadPageState();
}

class _DocumentUploadPageState extends State<DocumentUploadPage> {
  final Map<String, bool> _uploaded = {};
  final Map<String, bool> _uploading = {};

  static const Map<String, IconData> docIcons = {
    'Aadhaar Card': Icons.credit_card,
    'PAN Card': Icons.badge,
    'Salary Slip': Icons.receipt_long,
    'Property Documents': Icons.home_work,
    'Gold Valuation Certificate': Icons.stars,
    'Vehicle Registration': Icons.directions_car,
    'Property Papers': Icons.description,
    'Business Proof': Icons.business,
    'Admission Letter': Icons.school,
  };

  @override
  void initState() {
    super.initState();
    for (var doc in widget.requiredDocs) {
      _uploaded[doc] = false;
      _uploading[doc] = false;
    }
  }

  void _mockUpload(String doc) async {
    setState(() {
      _uploading[doc] = true;
    });
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _uploaded[doc] = true;
      _uploading[doc] = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Documents'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        color: Colors.grey[100],
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Please upload the following documents:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView.separated(
                  itemCount: widget.requiredDocs.length,
                  separatorBuilder: (context, i) => const SizedBox(height: 12),
                  itemBuilder: (context, i) {
                    final doc = widget.requiredDocs[i];
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                      child: ListTile(
                        leading: Icon(docIcons[doc] ?? Icons.description, color: Colors.deepPurple, size: 32),
                        title: Text(doc, style: const TextStyle(fontWeight: FontWeight.w600)),
                        trailing: _uploaded[doc]!
                            ? const Icon(Icons.check_circle, color: Colors.green, size: 28)
                            : _uploading[doc]!
                                ? const SizedBox(
                                    width: 28,
                                    height: 28,
                                    child: CircularProgressIndicator(strokeWidth: 3, color: Colors.deepPurple),
                                  )
                                : ElevatedButton(
                                    onPressed: () => _mockUpload(doc),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.deepPurple,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: const Text('Upload'),
                                  ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _uploaded.values.every((v) => v)
                    ? () {
                        // Proceed to next step (e.g., KYC page)
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Continue', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 