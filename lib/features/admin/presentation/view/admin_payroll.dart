import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hready/features/payroll/presentation/view_model/payroll_bloc.dart';
import 'package:hready/features/payroll/presentation/view_model/payroll_event.dart';
import 'package:hready/features/payroll/presentation/view_model/payroll_state.dart';
import 'package:hready/core/extensions/app_extensions.dart';
import 'package:hready/app/service_locator/service_locator.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class AdminPayroll extends StatefulWidget {
  const AdminPayroll({super.key});

  @override
  State<AdminPayroll> createState() => _AdminPayrollState();
}

class _AdminPayrollState extends State<AdminPayroll> with TickerProviderStateMixin {
  late TabController _tabController;
  int selectedMonth = DateTime.now().month;
  int selectedYear = DateTime.now().year;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadData();
  }

  void _loadData() {
    context.read<PayrollBloc>().add(const LoadPayrolls());
    context.read<PayrollBloc>().add(const LoadPayrollStats());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<PayrollBloc>()..add(const LoadPayrolls())..add(const LoadPayrollStats()),
      child: BlocListener<PayrollBloc, PayrollState>(
        listener: (context, state) {
          if (state is PayrollError) {
            context.showErrorSnackBar(state.message);
          } else if (state is PayrollGenerated) {
            context.showSuccessSnackBar('Payroll generated successfully!');
          } else if (state is PayrollApproved) {
            context.showSuccessSnackBar('Payroll approved successfully!');
          } else if (state is PayrollMarkedAsPaid) {
            context.showSuccessSnackBar('Payroll marked as paid!');
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Payroll Management'),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            elevation: 0,
            bottom: TabBar(
              controller: _tabController,
              indicatorColor: Colors.white,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              tabs: const [
                Tab(text: 'Overview', icon: Icon(Icons.dashboard)),
                Tab(text: 'Payrolls', icon: Icon(Icons.payment)),
                Tab(text: 'Actions', icon: Icon(Icons.settings)),
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              _buildOverviewTab(),
              _buildPayrollsTab(),
              _buildActionsTab(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOverviewTab() {
    return BlocBuilder<PayrollBloc, PayrollState>(
      builder: (context, state) {
        if (state is PayrollLoading) {
          return _buildOverviewShimmer();
        } else if (state is PayrollStatsLoaded) {
          return _buildOverviewContent(state.stats);
        } else if (state is PayrollError) {
          return Center(child: Text('Error: ${state.message}'));
        }
        return const Center(child: Text('No data available'));
      },
    );
  }

  Widget _buildOverviewShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: Container(height: 100, color: Colors.white)),
                const SizedBox(width: 16),
                Expanded(child: Container(height: 100, color: Colors.white)),
                const SizedBox(width: 16),
                Expanded(child: Container(height: 100, color: Colors.white)),
              ],
            ),
            const SizedBox(height: 24),
            Container(height: 200, color: Colors.white),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewContent(Map<String, dynamic> stats) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stats Cards
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Total Payrolls',
                  stats['totalPayrolls']?.toString() ?? '0',
                  Icons.payment,
                  Colors.blue,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  'Pending',
                  stats['pendingPayrolls']?.toString() ?? '0',
                  Icons.pending,
                  Colors.orange,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  'Paid',
                  stats['paidPayrolls']?.toString() ?? '0',
                  Icons.check_circle,
                  Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Month/Year Selector
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      value: selectedMonth,
                      decoration: const InputDecoration(
                        labelText: 'Month',
                        border: OutlineInputBorder(),
                      ),
                      items: List.generate(12, (index) => index + 1)
                          .map((month) => DropdownMenuItem(
                                value: month,
                                child: Text(DateFormat('MMMM').format(DateTime(2024, month))),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedMonth = value!;
                        });
                        _loadData();
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      value: selectedYear,
                      decoration: const InputDecoration(
                        labelText: 'Year',
                        border: OutlineInputBorder(),
                      ),
                      items: List.generate(5, (index) => DateTime.now().year - 2 + index)
                          .map((year) => DropdownMenuItem(
                                value: year,
                                child: Text(year.toString()),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedYear = value!;
                        });
                        _loadData();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          
          // Quick Actions
          const Text(
            'Quick Actions',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _showGeneratePayrollDialog(),
                  icon: const Icon(Icons.add),
                  label: const Text('Generate Payroll'),
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
                  onPressed: () => _showBulkApproveDialog(),
                  icon: const Icon(Icons.approval),
                  label: const Text('Bulk Approve'),
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
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPayrollsTab() {
    return BlocBuilder<PayrollBloc, PayrollState>(
      builder: (context, state) {
        if (state is PayrollLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is PayrollsLoaded) {
          return _buildPayrollsList(state.payrolls);
        } else if (state is PayrollError) {
          return Center(child: Text('Error: ${state.message}'));
        }
        return const Center(child: Text('No payrolls available'));
      },
    );
  }

  Widget _buildPayrollsList(List<dynamic> payrolls) {
    if (payrolls.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.payment, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No payrolls found',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              'Generate payrolls to see them here',
              style: TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: payrolls.length,
      itemBuilder: (context, index) {
        final payroll = payrolls[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: _getStatusColor(payroll.status),
              child: Icon(
                _getStatusIcon(payroll.status),
                color: Colors.white,
              ),
            ),
            title: Text(payroll.employeeName ?? 'Unknown Employee'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${DateFormat('MMMM yyyy').format(DateTime(payroll.year, payroll.month))}'),
                Text('Net Salary: ${_formatCurrency(payroll.netSalary)}'),
              ],
            ),
            trailing: PopupMenuButton<String>(
              onSelected: (value) => _handlePayrollAction(value, payroll),
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'view', child: Text('View Details')),
                const PopupMenuItem(value: 'approve', child: Text('Approve')),
                const PopupMenuItem(value: 'mark_paid', child: Text('Mark as Paid')),
                const PopupMenuItem(value: 'delete', child: Text('Delete')),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Payroll Actions',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          
          // Generate Payroll Section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Generate New Payroll',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => _showGeneratePayrollDialog(),
                    icon: const Icon(Icons.add),
                    label: const Text('Generate Payroll'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Bulk Operations Section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Bulk Operations',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _showBulkApproveDialog(),
                          icon: const Icon(Icons.approval),
                          label: const Text('Bulk Approve'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _showBulkPayDialog(),
                          icon: const Icon(Icons.payment),
                          label: const Text('Bulk Pay'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
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
          
          const SizedBox(height: 16),
          
          // Settings Section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Payroll Settings',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    leading: const Icon(Icons.settings),
                    title: const Text('Payroll Configuration'),
                    subtitle: const Text('Configure payroll settings and rules'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () => _showPayrollSettings(),
                  ),
                  ListTile(
                    leading: const Icon(Icons.account_balance),
                    title: const Text('Bank Account Management'),
                    subtitle: const Text('Manage employee bank accounts'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () => _showBankAccountManagement(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
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
    return amount.currency;
  }

  void _handlePayrollAction(String action, dynamic payroll) {
    switch (action) {
      case 'view':
        _showPayrollDetails(payroll);
        break;
      case 'approve':
        context.read<PayrollBloc>().add(ApprovePayroll(payroll.id));
        break;
      case 'mark_paid':
        _showMarkAsPaidDialog(payroll);
        break;
      case 'delete':
        _deletePayroll(payroll.id);
        break;
    }
  }

  void _showGeneratePayrollDialog() {
    Navigator.of(context).pop(); // Close any existing dialog
    context.showSnackBar(
      'Generate Payroll feature coming soon!',
    );
  }

  void _showBulkApproveDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Bulk Approve Payrolls'),
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

  void _showBulkPayDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Bulk Mark as Paid'),
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

  void _showPayrollDetails(dynamic payroll) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Payroll Details - ${payroll.employeeName}'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Month/Year', '${DateFormat('MMMM yyyy').format(DateTime(payroll.year, payroll.month))}'),
              _buildDetailRow('Status', payroll.status.toUpperCase()),
              _buildDetailRow('Basic Salary', _formatCurrency(payroll.basicSalary)),
              _buildDetailRow('Total Allowances', _formatCurrency(payroll.totalAllowances)),
              _buildDetailRow('Total Deductions', _formatCurrency(payroll.totalDeductions)),
              _buildDetailRow('Overtime', _formatCurrency(payroll.overtime['amount'] ?? 0.0)),
              _buildDetailRow('Total Bonuses', _formatCurrency(payroll.totalBonuses)),
              _buildDetailRow('Leave Deductions', _formatCurrency(payroll.leaves['deduction'] ?? 0.0)),
              const Divider(),
              _buildDetailRow('Gross Salary', _formatCurrency(payroll.grossSalary), isTotal: true),
              _buildDetailRow('Net Salary', _formatCurrency(payroll.netSalary), isTotal: true),
            ],
          ),
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

  Widget _buildDetailRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? Colors.blue : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  void _showMarkAsPaidDialog(dynamic payroll) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Mark as Paid'),
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

  void _deletePayroll(String payrollId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Payroll'),
        content: const Text('Are you sure you want to delete this payroll?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<PayrollBloc>().add(DeletePayroll(payrollId));
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showPayrollSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Payroll Settings'),
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

  void _showBankAccountManagement() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Bank Account Management'),
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