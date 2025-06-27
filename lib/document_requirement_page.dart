import 'package:flutter/material.dart';
import 'document_upload_page.dart';

class DocumentRequirementPage extends StatelessWidget {
  final String loanType;
  const DocumentRequirementPage({Key? key, required this.loanType}) : super(key: key);

  // Example document matrix
  static const Map<String, List<String>> documentMatrix = {
    'Personal Loan': ['Aadhaar Card', 'PAN Card', 'Salary Slip'],
    'Home Loan': ['Aadhaar Card', 'PAN Card', 'Salary Slip', 'Property Documents'],
    'Gold Loan': ['Aadhaar Card', 'PAN Card', 'Gold Valuation Certificate'],
    'Vehicle Loan': ['Aadhaar Card', 'PAN Card', 'Vehicle Registration'],
    'Loan Against Property': ['Aadhaar Card', 'PAN Card', 'Property Papers'],
    'Business Loan': ['Aadhaar Card', 'PAN Card', 'Business Proof'],
    'Education Loan': ['Aadhaar Card', 'PAN Card', 'Admission Letter'],
  };

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
  Widget build(BuildContext context) {
    final requiredDocs = documentMatrix[loanType] ?? [];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Required Documents'),
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
              Text(
                'Documents required for $loanType:',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView.separated(
                  itemCount: requiredDocs.length,
                  separatorBuilder: (context, i) => const SizedBox(height: 12),
                  itemBuilder: (context, i) {
                    final doc = requiredDocs[i];
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                      child: ListTile(
                        leading: Icon(docIcons[doc] ?? Icons.description, color: Colors.deepPurple, size: 32),
                        title: Text(doc, style: const TextStyle(fontWeight: FontWeight.w600)),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DocumentUploadPage(requiredDocs: requiredDocs),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Upload Documents', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 