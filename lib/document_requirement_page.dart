import 'package:flutter/material.dart';
import 'document_upload_page.dart';

class DocumentRequirementPage extends StatelessWidget {
  final String loanType;
  const DocumentRequirementPage({Key? key, required this.loanType}) : super(key: key);

  // Example document matrix
  static const Map<String, List<String>> documentMatrix = {
    'Home Loan': [
      'Identity Proof',
      'Address Proof',
      'Passport Photos',
      'Income Proof (Salaried)',
      'Income Proof (Non-Salaried)',
      'Bank Statement (6 months)',
      'Property Documents',
    ],
    'Gold Loan': [
      'Passport Photos',
      'Identity Proof',
      'Address Proof',
      'NR Customer Documents',
    ],
    'Vehicle Loan': [
      'Passport Photos',
      'Identity Proof',
      'Address Proof',
      'Age Proof',
      'NR Customer Documents',
    ],
    'Loan Against Property': [
      'Identity Proof',
      'Address Proof',
      'Income Proof (Salaried)',
      'Income Proof (Non-Salaried)',
      'Bank Statement (6 months)',
      'Property Documents',
    ],
    'Personal Loan': [
      'Identity/Address Proof',
      'Bank Statement (3 months)',
      'Passbook (6 months)',
      'Salary Slip',
      'Form 16',
    ],
    'Business Loan': [
      'PAN Card',
      'Identity Proof',
      'Address Proof',
      'Bank Statement (6 months)',
      'ITR',
      'Balance Sheet',
      'Profit & Loss Account',
      'Proof of Continuation',
      'Other Mandatory Documents',
    ],
    'Education Loan': [
      'Identity Proof',
      'Residence Proof',
      'Passport Photo',
      'ITR/Income Proof',
      'Bank Statement',
    ],
  };

  static const Map<String, IconData> docIcons = {
    'Identity Proof': Icons.perm_identity,
    'Address Proof': Icons.home,
    'Passport Photos': Icons.photo,
    'Income Proof (Salaried)': Icons.receipt_long,
    'Income Proof (Non-Salaried)': Icons.receipt,
    'Bank Statement (6 months)': Icons.account_balance,
    'Property Documents': Icons.description,
    'NR Customer Documents': Icons.language,
    'Age Proof': Icons.cake,
    'Identity/Address Proof': Icons.perm_identity,
    'Bank Statement (3 months)': Icons.account_balance,
    'Passbook (6 months)': Icons.book,
    'Salary Slip': Icons.receipt_long,
    'Form 16': Icons.assignment,
    'PAN Card': Icons.badge,
    'ITR': Icons.insert_drive_file,
    'Balance Sheet': Icons.table_chart,
    'Profit & Loss Account': Icons.show_chart,
    'Proof of Continuation': Icons.verified,
    'Other Mandatory Documents': Icons.folder_special,
    'Residence Proof': Icons.home,
    'Passport Photo': Icons.photo,
    'ITR/Income Proof': Icons.insert_drive_file,
    'Bank Statement': Icons.account_balance,
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