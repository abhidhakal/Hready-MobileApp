import 'package:flutter/material.dart';
import 'package:hready/features/payroll/domain/use_cases/get_employee_payroll_history.dart';
import 'package:hready/features/payroll/domain/use_cases/get_salary_by_employee.dart';
import 'package:hready/features/payroll/domain/use_cases/get_bank_accounts_by_employee.dart';
import 'package:hready/features/payroll/domain/entities/salary.dart';
import 'package:hready/features/payroll/domain/entities/bank_account.dart';
import 'package:hready/app/service_locator/service_locator.dart';
import 'package:hready/features/auth/domain/use_cases/get_cached_user_use_case.dart';
import 'package:intl/intl.dart';

class EmployeePayroll extends StatefulWidget {
  const EmployeePayroll({super.key});

  @override
  State<EmployeePayroll> createState() => _EmployeePayrollState();
}

class _EmployeePayrollState extends State<EmployeePayroll> with TickerProviderStateMixin {
  late TabController _tabController;
  String? employeeId;
  List<dynamic> payrolls = [];
  Salary? salary;
  List<BankAccount> bankAccounts = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadEmployeeData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadEmployeeData() async {
    try {
      final cachedUser = await getIt<GetCachedUserUseCase>().call();
      
      if (cachedUser != null && cachedUser.userId != null) {
        setState(() {
          employeeId = cachedUser.userId;
        });
        
        // Load all data in parallel
        await Future.wait([
          _loadPayrollHistory(),
          _loadSalary(),
          _loadBankAccounts(),
        ]);
        
        setState(() {
          isLoading = false;
        });
      } else {
        setState(() {
          error = 'User ID not found';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'Failed to load employee data: $e';
        isLoading = false;
      });
    }
  }

  Future<void> _loadPayrollHistory() async {
    try {
      final payrollHistory = await getIt<GetEmployeePayrollHistory>().call(employeeId!);
      setState(() {
        payrolls = payrollHistory;
      });
    } catch (e) {
      print('Error loading payroll history: $e');
    }
  }

  Future<void> _loadSalary() async {
    try {
      final employeeSalary = await getIt<GetSalaryByEmployee>().call(employeeId!);
      setState(() {
        salary = employeeSalary;
      });
    } catch (e) {
      print('Error loading salary: $e');
    }
  }

  Future<void> _loadBankAccounts() async {
    try {
      final accounts = await getIt<GetBankAccountsByEmployee>().call(employeeId!);
      setState(() {
        bankAccounts = accounts;
      });
    } catch (e) {
      print('Error loading bank accounts: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Payroll'),
          backgroundColor: const Color(0xFFf5f5f5),
          foregroundColor: Colors.black,
          centerTitle: false,
          elevation: 0,
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: const Color(0xFF042F46),
            labelColor: const Color(0xFF042F46),
            unselectedLabelColor: Colors.grey,
            isScrollable: true,
            tabs: const [
              Tab(text: 'Overview', icon: Icon(Icons.dashboard)),
              Tab(text: 'Salary', icon: Icon(Icons.money)),
              Tab(text: 'Banking', icon: Icon(Icons.account_balance)),
              Tab(text: 'History', icon: Icon(Icons.history)),
            ],
          ),
        ),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    
    if (error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text('Error: $error'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadEmployeeData,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return TabBarView(
      controller: _tabController,
      children: [
        _buildOverviewTab(),
        _buildSalaryTab(),
        _buildBankingTab(),
        _buildHistoryTab(),
      ],
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stats Cards
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  'Net Salary',
                  salary?.netSalary != null ? _formatCurrency(salary!.netSalary) : 'N/A',
                  Icons.money,
                  const Color(0xFF042F46),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildSummaryCard(
                  'Paid This Year',
                  payrolls.where((p) => p.status == 'paid').length.toString(),
                  Icons.check_circle,
                  Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  'Pending',
                  payrolls.where((p) => p.status == 'approved').length.toString(),
                  Icons.pending,
                  Colors.orange,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildSummaryCard(
                  'Bank Account',
                  bankAccounts.isNotEmpty ? 'Yes' : 'No',
                  Icons.account_balance,
                  bankAccounts.isNotEmpty ? Colors.green : Colors.grey,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Recent Payrolls
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Recent Payrolls',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF042F46),
                  ),
                ),
                const SizedBox(height: 16),
                if (payrolls.isEmpty)
                  const Center(
                    child: Column(
                      children: [
                        Icon(Icons.receipt_long, size: 48, color: Colors.grey),
                        SizedBox(height: 8),
                        Text(
                          'No payroll records found',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                else
                  ...payrolls.take(3).map((payroll) => _buildRecentPayrollCard(payroll)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSalaryTab() {
    if (salary == null) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.money_off, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No Salary Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Your salary information will appear here once it is configured.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Salary Overview Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF042F46),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Current Salary Structure',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Effective: ${DateFormat('MMM dd, yyyy').format(salary!.effectiveDate)}',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Net Salary:',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      _formatCurrency(salary!.netSalary),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
                    // Salary Breakdown
          Column(
            children: [
              _buildBreakdownSection(
                'Basic Components',
                [
                  _buildBreakdownItem('Basic Salary', salary!.basicSalary),
                  _buildBreakdownItem('Housing Allowance', salary!.allowances['housing'] ?? 0),
                  _buildBreakdownItem('Transport Allowance', salary!.allowances['transport'] ?? 0),
                  _buildBreakdownItem('Meal Allowance', salary!.allowances['meal'] ?? 0),
                  _buildBreakdownItem('Medical Allowance', salary!.allowances['medical'] ?? 0),
                  _buildBreakdownItem('Other Allowance', salary!.allowances['other'] ?? 0),
                  _buildBreakdownItem('Total Allowances', salary!.totalAllowances, isTotal: true),
                ],
              ),
              const SizedBox(height: 16),
              _buildBreakdownSection(
                'Deductions',
                [
                  _buildBreakdownItem('Tax', salary!.deductions['tax'] ?? 0),
                  _buildBreakdownItem('Insurance', salary!.deductions['insurance'] ?? 0),
                  _buildBreakdownItem('Pension', salary!.deductions['pension'] ?? 0),
                  _buildBreakdownItem('Other Deduction', salary!.deductions['other'] ?? 0),
                  _buildBreakdownItem('Total Deductions', salary!.totalDeductions, isTotal: true),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBankingTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (bankAccounts.isEmpty)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.account_balance, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text(
                    'No Banking Information',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Add your banking information to receive salary payments.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => _showAddBankDialog(),
                    icon: const Icon(Icons.add),
                    label: const Text('Add Bank Account'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF042F46),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            )
          else
            ...bankAccounts.map((account) => _buildBankAccountCard(account)),
        ],
      ),
    );
  }

  Widget _buildHistoryTab() {
    if (payrolls.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No Payroll History',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Your payroll records will appear here once they are generated.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
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
            title: Text(
              DateFormat('MMMM yyyy').format(DateTime(payroll.year, payroll.month)),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Net Salary: ${_formatCurrency(payroll.netSalary)}'),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: _getStatusColor(payroll.status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    payroll.status.toUpperCase(),
                    style: TextStyle(
                      color: _getStatusColor(payroll.status),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => _showPayrollDetails(payroll),
          ),
        );
      },
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentPayrollCard(dynamic payroll) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat('MMM yyyy').format(DateTime(payroll.year, payroll.month)),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  _formatCurrency(payroll.netSalary),
                  style: const TextStyle(
                    color: Color(0xFF042F46),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getStatusColor(payroll.status).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              payroll.status.toUpperCase(),
              style: TextStyle(
                color: _getStatusColor(payroll.status),
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBreakdownSection(String title, List<Widget> items) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF042F46),
            ),
          ),
          const SizedBox(height: 16),
          ...items,
        ],
      ),
    );
  }

  Widget _buildBreakdownItem(String label, double amount, {bool isTotal = false}) {
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
            _formatCurrency(amount),
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 16 : 14,
              color: isTotal ? const Color(0xFF042F46) : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBankAccountCard(BankAccount account) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                account.bankName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF042F46),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: account.status == 'active' ? Colors.green : Colors.grey,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  account.status.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildBankDetailRow('Account Number', account.accountNumber),
          _buildBankDetailRow('Account Type', account.accountType),
          _buildBankDetailRow('Account Holder', account.accountHolderName),
          if (account.routingNumber != null)
            _buildBankDetailRow('Routing Number', account.routingNumber!),
          if (account.swiftCode != null)
            _buildBankDetailRow('SWIFT Code', account.swiftCode!),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _showEditBankDialog(account),
                  icon: const Icon(Icons.edit, size: 16),
                  label: const Text('Edit'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF042F46),
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBankDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  void _showPayrollDetails(dynamic payroll) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Payroll Details - ${DateFormat('MMMM yyyy').format(DateTime(payroll.year, payroll.month))}'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Status', payroll.status.toUpperCase()),
              _buildDetailRow('Basic Salary', _formatCurrency(payroll.basicSalary)),
              _buildDetailRow('Gross Salary', _formatCurrency(payroll.grossSalary)),
              _buildDetailRow('Net Salary', _formatCurrency(payroll.netSalary), isTotal: true),
              if (payroll.paymentDate != null) ...[
                const SizedBox(height: 8),
                _buildDetailRow('Payment Date', DateFormat('MMM dd, yyyy').format(DateTime.parse(payroll.paymentDate))),
              ],
              if (payroll.paymentMethod != null) ...[
                _buildDetailRow('Payment Method', payroll.paymentMethod),
              ],
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

  void _showAddBankDialog() {
    // TODO: Implement add bank dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Add bank account functionality coming soon!'),
      ),
    );
  }

  void _showEditBankDialog(BankAccount account) {
    // TODO: Implement edit bank dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Edit bank account functionality coming soon!'),
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
              color: isTotal ? const Color(0xFF042F46) : Colors.black87,
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
    return 'Rs. ${NumberFormat('#,##0.00').format(amount)}';
  }
} 