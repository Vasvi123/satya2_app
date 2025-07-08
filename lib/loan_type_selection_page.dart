import 'package:flutter/material.dart';
import 'document_requirement_page.dart';
import 'document_management_page.dart';

class LoanTypeSelectionPage extends StatefulWidget {
  const LoanTypeSelectionPage({Key? key}) : super(key: key);

  @override
  State<LoanTypeSelectionPage> createState() => _LoanTypeSelectionPageState();
}

class _LoanTypeSelectionPageState extends State<LoanTypeSelectionPage> {
  String? _selectedLoanType;
  final List<Map<String, dynamic>> _loanTypes = [
    {'name': 'Personal Loan', 'icon': Icons.account_balance_wallet},
    {'name': 'Home Loan', 'icon': Icons.home},
    {'name': 'Gold Loan', 'icon': Icons.account_balance},
    {'name': 'Vehicle Loan', 'icon': Icons.directions_car},
    {'name': 'Loan Against Property', 'icon': Icons.location_city},
    {'name': 'Business Loan', 'icon': Icons.business_center},
    {'name': 'Education Loan', 'icon': Icons.school},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Loan Type'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.folder),
            tooltip: 'Manage Documents',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DocumentManagementPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.grey[100],
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Choose the type of loan you want to apply for:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.35,
                  children: _loanTypes.map((loan) {
                    final isSelected = _selectedLoanType == loan['name'];
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedLoanType = loan['name'];
                        });
                      },
                      child: Card(
                        color: isSelected ? Colors.deepPurple[100] : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(
                            color: isSelected ? Colors.deepPurple : Colors.grey[300]!,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        elevation: isSelected ? 6 : 2,
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(loan['icon'], size: 40, color: Colors.deepPurple),
                              const SizedBox(height: 12),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                                child: Text(
                                  loan['name'],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: isSelected ? Colors.deepPurple : Colors.black87,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _selectedLoanType == null
                    ? null
                    : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DocumentRequirementPage(loanType: _selectedLoanType!),
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
                child: const Text('Next', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 