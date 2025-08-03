import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hready/features/payroll/presentation/view_model/payroll_bloc.dart';
import 'package:hready/features/payroll/presentation/view_model/payroll_event.dart';
import 'package:hready/features/payroll/presentation/view_model/payroll_state.dart';
import 'package:hready/app/service_locator/service_locator.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmployeePayroll extends StatefulWidget {
  const EmployeePayroll({super.key});

  @override
  State<EmployeePayroll> createState() => _EmployeePayrollState();
}

class _EmployeePayrollState extends State<EmployeePayroll> {
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
    if (employeeId != null && mounted) {
      context.read<PayrollBloc>().add(LoadEmployeePayrollHistory(employeeId!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<PayrollBloc>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Payroll'),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.account_balance),
              onPressed: () => _showBankAccountDialog(),
              tooltip: 'Bank Account',
            ),
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () => _showSettingsDialog(),
              tooltip: 'Settings',
            ),
          ],
        ),
        body: BlocBuilder<PayrollBloc, PayrollState>(
          builder: (context, state) {
            if (state is PayrollLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is EmployeePayrollHistoryLoaded) {
              return _buildPayrollHistory(state.payrolls);
            } else if (state is PayrollError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            return const Center(child: Text('No payroll history available'));
          },
        ),
      ),
    );
  }

  Widget _buildPayrollHistory(List<dynamic> payrolls) {
    if (payrolls.isEmpty) {
      return const Center(
        child: Text('No payroll history found'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: payrolls.length,
      itemBuilder: (context, index) {
        final payroll = payrolls[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: _getStatusColor(payroll.status),
              child: Icon(
                _getStatusIcon(payroll.status),
                color: Colors.white,
              ),
            ),
            title: Text(DateFormat('MMMM yyyy').format(DateTime(payroll.year, payroll.month))),
            subtitle: Text('Net Salary: ${_formatCurrency(payroll.netSalary)}'),
            trailing: Text(
              payroll.status.toUpperCase(),
              style: TextStyle(
                color: _getStatusColor(payroll.status),
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () => _viewDetails(payroll),
          ),
        );
      },
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'draft':
        return Colors.grey;
      case 'approved':
        return Colors.orange;
      case 'paid':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'draft':
        return Icons.edit;
      case 'approved':
        return Icons.check;
      case 'paid':
        return Icons.payment;
      default:
        return Icons.help;
    }
  }

  String _formatCurrency(double amount) {
    return 'Rs. ${NumberFormat('#,##0.00').format(amount)}';
  }

  void _viewDetails(dynamic payroll) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Payroll Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Month: ${DateFormat('MMMM yyyy').format(DateTime(payroll.year, payroll.month))}'),
            Text('Status: ${payroll.status.toUpperCase()}'),
            Text('Basic Salary: ${_formatCurrency(payroll.basicSalary)}'),
            Text('Net Salary: ${_formatCurrency(payroll.netSalary)}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showBankAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Bank Account'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('This feature will be implemented soon.'),
            SizedBox(height: 16),
            Text('You will be able to:'),
            Text('• View your bank accounts'),
            Text('• Add new bank accounts'),
            Text('• Update account details'),
            Text('• Set default account'),
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

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Payroll Settings'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('This feature will be implemented soon.'),
            SizedBox(height: 16),
            Text('You will be able to:'),
            Text('• Configure notification preferences'),
            Text('• Set payment preferences'),
            Text('• Manage privacy settings'),
            Text('• Export payroll data'),
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
} 