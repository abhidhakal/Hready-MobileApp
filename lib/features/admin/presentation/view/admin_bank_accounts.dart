import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hready/features/payroll/presentation/view_model/payroll_bloc.dart';
import 'package:hready/features/payroll/presentation/view_model/payroll_event.dart';
import 'package:hready/features/payroll/presentation/view_model/payroll_state.dart';
import 'package:intl/intl.dart';

class AdminBankAccounts extends StatefulWidget {
  const AdminBankAccounts({super.key});

  @override
  State<AdminBankAccounts> createState() => _AdminBankAccountsState();
}

class _AdminBankAccountsState extends State<AdminBankAccounts> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    // TODO: Add bank account loading events
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bank Account Management'),
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
              'Bank Account Management',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Manage employee bank accounts for payroll payments',
              style: TextStyle(fontSize: 16, color: Colors.grey),
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
                            onPressed: () => _showAddBankAccountDialog(),
                            icon: const Icon(Icons.add),
                            label: const Text('Add Account'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => _showBulkImportDialog(),
                            icon: const Icon(Icons.upload),
                            label: const Text('Bulk Import'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Bank Account Statistics
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Bank Account Statistics',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            'Total Accounts',
                            '0',
                            Icons.account_balance,
                            Colors.blue,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildStatCard(
                            'Active Accounts',
                            '0',
                            Icons.check_circle,
                            Colors.green,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildStatCard(
                            'Pending Verification',
                            '0',
                            Icons.pending,
                            Colors.orange,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Bank Account List Placeholder
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
                          'Employee Bank Accounts',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        TextButton(
                          onPressed: () => _showBankAccountList(),
                          child: const Text('View All'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Center(
                      child: Column(
                        children: [
                          Icon(Icons.account_balance, size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text(
                            'No bank accounts found',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Add bank accounts to see them here',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Bank Account Features
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Bank Account Features',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    _buildFeatureItem('Account Verification', 'Verify bank account details', Icons.verified),
                    _buildFeatureItem('Default Account Setting', 'Set default payment account', Icons.star),
                    _buildFeatureItem('Account History', 'View account transaction history', Icons.history),
                    _buildFeatureItem('Payment Methods', 'Configure payment methods', Icons.payment),
                    _buildFeatureItem('Security Settings', 'Manage account security', Icons.security),
                    _buildFeatureItem('Export Data', 'Export bank account data', Icons.download),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Supported Banks
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Supported Banks',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    _buildBankItem('Nepal Bank', 'Nepal Bank Limited', Icons.account_balance),
                    _buildBankItem('NIC Asia Bank', 'NIC Asia Bank Limited', Icons.account_balance),
                    _buildBankItem('Nabil Bank', 'Nabil Bank Limited', Icons.account_balance),
                    _buildBankItem('Standard Chartered', 'Standard Chartered Bank Nepal', Icons.account_balance),
                    _buildBankItem('Other Banks', 'Other commercial banks', Icons.account_balance),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, size: 32, color: color),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildFeatureItem(String title, String description, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      subtitle: Text(description),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () => _showFeatureDetails(title),
    );
  }

  Widget _buildBankItem(String title, String description, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Colors.green),
      title: Text(title),
      subtitle: Text(description),
      trailing: const Icon(Icons.check_circle, color: Colors.green, size: 20),
      onTap: () => _showBankDetails(title),
    );
  }

  void _showAddBankAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Bank Account'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('This feature will be implemented soon.'),
            SizedBox(height: 16),
            Text('You will be able to:'),
            Text('• Select employee'),
            Text('• Enter bank details'),
            Text('• Verify account information'),
            Text('• Set as default account'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showBulkImportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Bulk Import Bank Accounts'),
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

  void _showBankAccountList() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Employee Bank Accounts'),
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

  void _showFeatureDetails(String feature) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$feature Details'),
        content: Text('Details for $feature will be implemented soon.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showBankDetails(String bank) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$bank Details'),
        content: Text('Details for $bank will be implemented soon.'),
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