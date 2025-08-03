import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hready/features/payroll/presentation/view_model/payroll_bloc.dart';
import 'package:hready/features/payroll/presentation/view_model/payroll_event.dart';
import 'package:hready/features/payroll/presentation/view_model/payroll_state.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmployeeSalary extends StatefulWidget {
  const EmployeeSalary({super.key});

  @override
  State<EmployeeSalary> createState() => _EmployeeSalaryState();
}

class _EmployeeSalaryState extends State<EmployeeSalary> {
  String? employeeId;

  @override
  void initState() {
    super.initState();
    _loadEmployeeId();
  }

  Future<void> _loadEmployeeId() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    setState(() {
      employeeId = userId;
    });
    // TODO: Load salary data when salary BLoC is implemented
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Salary'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            const Text(
              'My Salary Information',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'View your current salary and benefits',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 24),

            // Current Salary Card
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Current Salary',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'ACTIVE',
                            style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildSalaryRow('Basic Salary', 'Rs. 50,000.00'),
                    _buildSalaryRow('Housing Allowance', 'Rs. 15,000.00'),
                    _buildSalaryRow('Transport Allowance', 'Rs. 5,000.00'),
                    _buildSalaryRow('Meal Allowance', 'Rs. 3,000.00'),
                    _buildSalaryRow('Medical Allowance', 'Rs. 2,000.00'),
                    const Divider(),
                    _buildSalaryRow('Gross Salary', 'Rs. 75,000.00', isTotal: true),
                    _buildSalaryRow('Tax Deduction', 'Rs. 5,000.00'),
                    _buildSalaryRow('Insurance', 'Rs. 1,000.00'),
                    const Divider(),
                    _buildSalaryRow('Net Salary', 'Rs. 69,000.00', isTotal: true),
                    const SizedBox(height: 16),
                    const Text(
                      'Effective Date: January 1, 2024',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Salary History
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Salary History',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        TextButton(
                          onPressed: () => _showSalaryHistory(),
                          child: const Text('View All'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildHistoryItem('January 2024', 'Rs. 69,000.00', 'Active'),
                    _buildHistoryItem('December 2023', 'Rs. 65,000.00', 'Completed'),
                    _buildHistoryItem('November 2023', 'Rs. 65,000.00', 'Completed'),
                    _buildHistoryItem('October 2023', 'Rs. 60,000.00', 'Completed'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Benefits and Allowances
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Benefits & Allowances',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    _buildBenefitItem('Housing Allowance', 'Rs. 15,000/month', Icons.home, Colors.blue),
                    _buildBenefitItem('Transport Allowance', 'Rs. 5,000/month', Icons.directions_car, Colors.green),
                    _buildBenefitItem('Meal Allowance', 'Rs. 3,000/month', Icons.restaurant, Colors.orange),
                    _buildBenefitItem('Medical Allowance', 'Rs. 2,000/month', Icons.medical_services, Colors.red),
                    _buildBenefitItem('Internet Allowance', 'Rs. 1,000/month', Icons.wifi, Colors.purple),
                    _buildBenefitItem('Phone Allowance', 'Rs. 500/month', Icons.phone, Colors.teal),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Deductions
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Deductions',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    _buildDeductionItem('Income Tax', 'Rs. 5,000/month', Icons.receipt, Colors.red),
                    _buildDeductionItem('Insurance Premium', 'Rs. 1,000/month', Icons.security, Colors.orange),
                    _buildDeductionItem('Provident Fund', 'Rs. 3,750/month', Icons.account_balance, Colors.blue),
                    _buildDeductionItem('Other Deductions', 'Rs. 250/month', Icons.remove_circle, Colors.grey),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Quick Actions
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Quick Actions',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => _downloadSalarySlip(),
                            icon: const Icon(Icons.download),
                            label: const Text('Download Slip'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => _requestSalaryReview(),
                            icon: const Icon(Icons.edit),
                            label: const Text('Request Review'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSalaryRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 16 : 14,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 16 : 14,
              color: isTotal ? Colors.blue : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(String period, String amount, String status) {
    Color statusColor = status == 'Active' ? Colors.green : Colors.grey;
    
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: statusColor.withOpacity(0.2),
        child: Icon(
          status == 'Active' ? Icons.check : Icons.history,
          color: statusColor,
          size: 20,
        ),
      ),
      title: Text(period),
      subtitle: Text(amount),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: statusColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          status,
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
      ),
      onTap: () => _showSalaryDetails(period, amount),
    );
  }

  Widget _buildBenefitItem(String title, String amount, IconData icon, Color color) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title),
      subtitle: Text(amount),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () => _showBenefitDetails(title),
    );
  }

  Widget _buildDeductionItem(String title, String amount, IconData icon, Color color) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title),
      subtitle: Text(amount),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () => _showDeductionDetails(title),
    );
  }

  void _showSalaryHistory() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Salary History'),
        content: const Text('This feature will be implemented soon.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showSalaryDetails(String period, String amount) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Salary Details - $period'),
        content: Text('Detailed breakdown for $period will be implemented soon.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showBenefitDetails(String benefit) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$benefit Details'),
        content: Text('Details for $benefit will be implemented soon.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showDeductionDetails(String deduction) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$deduction Details'),
        content: Text('Details for $deduction will be implemented soon.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _downloadSalarySlip() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Download Salary Slip'),
        content: const Text('This feature will be implemented soon.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _requestSalaryReview() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Request Salary Review'),
        content: const Text('This feature will be implemented soon.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
} 