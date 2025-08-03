import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hready/features/employee/presentation/view_model/employee_bloc.dart';
import 'package:hready/features/payroll/domain/use_cases/get_all_salaries.dart';
import 'package:hready/features/payroll/domain/use_cases/get_all_payrolls.dart';
import 'package:hready/features/payroll/domain/use_cases/get_bank_accounts_by_employee.dart';
import 'package:hready/features/payroll/domain/entities/salary.dart';
import 'package:hready/features/payroll/domain/entities/payroll.dart';
import 'package:hready/features/payroll/domain/entities/bank_account.dart';
import 'package:hready/features/employee/domain/entities/employee_entity.dart';
import 'package:hready/core/extensions/app_extensions.dart';
import 'package:hready/app/service_locator/service_locator.dart';
import 'package:intl/intl.dart';

class AdminPayroll extends StatefulWidget {
  const AdminPayroll({super.key});

  @override
  State<AdminPayroll> createState() => _AdminPayrollState();
}

class _AdminPayrollState extends State<AdminPayroll> with TickerProviderStateMixin {
  late TabController _tabController;
  Map<String, List<BankAccount>> employeeBankAccounts = {};
  bool isLoadingBankAccounts = false;
  double? salaryBudget;
  int selectedMonth = DateTime.now().month;
  int selectedYear = DateTime.now().year;
  bool showAllMonths = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadSalaryBudget();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadSalaryBudget() async {
    // For now, we'll set a default budget. In a real app, this would come from an API
    setState(() {
      salaryBudget = 500000.0; // Default budget
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Payroll Management'),
          backgroundColor: const Color(0xFFf5f5f5),
          foregroundColor: Colors.black,
          centerTitle: false,
          elevation: 0,
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: const Color(0xFF042F46),
            labelColor: const Color(0xFF042F46),
            unselectedLabelColor: Colors.grey,
            tabs: const [
              Tab(text: 'Overview', icon: Icon(Icons.dashboard)),
              Tab(text: 'Recent Payrolls', icon: Icon(Icons.receipt_long)),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildOverviewTab(),
            _buildRecentPayrollsTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewTab() {
    return FutureBuilder<List<Salary>>(
      future: getIt<GetAllSalaries>().call(),
      builder: (context, salarySnapshot) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<EmployeeBloc>(
              create: (_) => getIt<EmployeeBloc>()..add(LoadEmployees()),
            ),
          ],
          child: BlocBuilder<EmployeeBloc, EmployeeState>(
            builder: (context, employeeState) {
              if (salarySnapshot.connectionState == ConnectionState.waiting || 
                  employeeState is EmployeeLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (salarySnapshot.hasError) {
                return Center(child: Text('Error: ${salarySnapshot.error}'));
              } else if (employeeState is EmployeeError) {
                return Center(child: Text('Error: ${employeeState.error}'));
              } else if (employeeState is EmployeeLoaded && salarySnapshot.hasData) {
                // Use FutureBuilder to load bank accounts properly
                return FutureBuilder<void>(
                  future: _loadAllBankAccountsOnce(employeeState.employees),
                  builder: (context, bankSnapshot) {
                    return _buildOverviewContent(employeeState.employees, salarySnapshot.data!);
                  },
                );
              }
              return const Center(child: Text('No data available'));
            },
          ),
        );
      },
    );
  }

  Widget _buildOverviewContent(List<EmployeeEntity> employees, List<Salary> salaries) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Professional Notice Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
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
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline,
                  color: Colors.white,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Payroll Generation',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Advanced payroll generation features are available on the web platform. Mobile app functionality coming soon.',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Summary Cards
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  'Total Employees',
                  employees.length.toString(),
                  Icons.people,
                  const Color(0xFF042F46),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildSummaryCard(
                  'Active Salaries',
                  salaries.where((s) => s.status == 'active').length.toString(),
                  Icons.money,
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
                  'Salary Budget',
                  salaryBudget != null ? _formatCurrency(salaryBudget!) : 'N/A',
                  Icons.account_balance_wallet,
                  Colors.black,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildSummaryCard(
                  'Avg Salary',
                  _formatCurrency(_calculateAverageSalary(salaries)),
                  Icons.trending_up,
                  Colors.orange,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          // Employee Salary List
          const Text(
            'Employee Salaries & Bank Information',
            style: TextStyle(
              fontSize: 20, 
              fontWeight: FontWeight.bold,
              color: Color(0xFF042F46),
            ),
          ),
          const SizedBox(height: 16),
          
          ...employees.map((employee) => _buildEmployeeSalaryCard(employee, salaries)),
        ],
      ),
    );
  }

  Widget _buildRecentPayrollsTab() {
    return FutureBuilder<List<Payroll>>(
      future: getIt<GetAllPayrolls>().call(),
      builder: (context, payrollSnapshot) {
        if (payrollSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (payrollSnapshot.hasError) {
          return Center(child: Text('Error: ${payrollSnapshot.error}'));
        } else if (payrollSnapshot.hasData) {
          final payrolls = payrollSnapshot.data!;
          if (payrolls.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.receipt_long, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No Recent Payrolls',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Payroll records will appear here once they are generated.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }
          
          // Sort by date (most recent first)
          payrolls.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          
          // Filter payrolls by month/year if not showing all months
          final filteredPayrolls = showAllMonths 
              ? payrolls 
              : payrolls.where((payroll) => 
                  payroll.month == selectedMonth && payroll.year == selectedYear
                ).toList();
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Month/Year Filter Section
                Container(
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
                        'Filter Payrolls',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF042F46),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: CheckboxListTile(
                              title: const Text('Show All Months'),
                              value: showAllMonths,
                              onChanged: (value) {
                                setState(() {
                                  showAllMonths = value ?? false;
                                });
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ],
                      ),
                      if (!showAllMonths) ...[
                        const SizedBox(height: 12),
                        Row(
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
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Payroll Count
                Text(
                  '${filteredPayrolls.length} Payroll${filteredPayrolls.length != 1 ? 's' : ''} Found',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF042F46),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Payrolls List
                ...filteredPayrolls.map((payroll) => Container(
                  margin: const EdgeInsets.only(bottom: 12),
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
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: _getStatusColor(payroll.status),
                      child: Icon(
                        _getStatusIcon(payroll.status),
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      payroll.employeeName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${DateFormat('MMMM yyyy').format(DateTime(payroll.year, payroll.month))}'),
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
                )).toList(),
              ],
            ),
          );
        }
        return const Center(child: Text('No payroll data available'));
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
        children: [
          Icon(icon, size: 32, color: color),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20, 
              fontWeight: FontWeight.bold, 
              color: color
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEmployeeSalaryCard(EmployeeEntity employee, List<Salary> salaries) {
    final employeeSalary = salaries.firstWhere(
      (salary) => salary.employeeId == employee.employeeId && salary.status == 'active',
      orElse: () => Salary(
        id: '',
        employeeId: employee.employeeId ?? '',
        employeeName: employee.name,
        basicSalary: 0,
        allowances: {},
        deductions: {},
        currency: 'Rs.',
        status: 'inactive',
        effectiveDate: DateTime.now(),
        createdBy: '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      child: ExpansionTile(
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: const Color(0xFF042F46),
              child: Text(
                employee.name.isNotEmpty ? employee.name[0].toUpperCase() : 'E',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    employee.name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    '${employee.department} • ${employee.position}',
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  employeeSalary.status == 'active' ? Icons.check_circle : Icons.cancel,
                  color: employeeSalary.status == 'active' ? Colors.green : Colors.red,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  employeeSalary.status == 'active' ? 'Active Salary' : 'No Active Salary',
                  style: TextStyle(
                    color: employeeSalary.status == 'active' ? Colors.green : Colors.red,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Salary Information
                const Text(
                  'Salary Information',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF042F46)),
                ),
                const SizedBox(height: 8),
                if (employeeSalary.status == 'active') ...[
                  _buildDetailRow('Basic Salary', _formatCurrency(employeeSalary.basicSalary)),
                  _buildDetailRow('Total Allowances', _formatCurrency(employeeSalary.totalAllowances)),
                  _buildDetailRow('Total Deductions', _formatCurrency(employeeSalary.totalDeductions)),
                  _buildDetailRow('Gross Salary', _formatCurrency(employeeSalary.grossSalary)),
                  _buildDetailRow('Net Salary', _formatCurrency(employeeSalary.netSalary), isTotal: true),
                ] else ...[
                  const Text(
                    'No active salary configured',
                    style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
                  ),
                ],
                
                const SizedBox(height: 16),
                
                // Bank Information
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Bank Information',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF042F46)),
                        ),
                        if (isLoadingBankAccounts && !employeeBankAccounts.containsKey(employee.employeeId ?? '')) ...[
                          const SizedBox(width: 8),
                          const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ],
                      ],
                    ),
                    TextButton.icon(
                      onPressed: () => _loadBankAccounts(employee),
                      icon: const Icon(Icons.refresh, size: 16),
                      label: const Text('Refresh'),
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF042F46),
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                
                // Bank Accounts List
                _buildBankAccountsSection(employee),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBankAccountsSection(EmployeeEntity employee) {
    final bankAccounts = employeeBankAccounts[employee.employeeId ?? ''] ?? [];
    final hasLoadedForEmployee = employeeBankAccounts.containsKey(employee.employeeId ?? '');
    
    // Show loading if we're loading bank accounts and haven't loaded for this employee yet
    if (isLoadingBankAccounts && !hasLoadedForEmployee && employee.employeeId != null) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: CircularProgressIndicator(),
        ),
      );
    }
    
    if (bankAccounts.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Row(
          children: [
            Icon(Icons.account_balance, color: Colors.grey),
            SizedBox(width: 8),
            Text(
              'No bank accounts found',
              style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
            ),
          ],
        ),
      );
    }
    
    return Column(
      children: bankAccounts.map((account) => Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  account.bankName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: account.status == 'active' ? Colors.green : Colors.grey,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    account.status,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _buildDetailRow('Account Number', account.accountNumber),
            _buildDetailRow('Account Holder', account.accountHolderName),
            _buildDetailRow('Account Type', account.accountType),
            if (account.routingNumber != null && account.routingNumber!.isNotEmpty)
              _buildDetailRow('Routing Number', account.routingNumber!),
            if (account.swiftCode != null && account.swiftCode!.isNotEmpty)
              _buildDetailRow('SWIFT Code', account.swiftCode!),
          ],
        ),
      )).toList(),
    );
  }

  void _showPayrollDetails(Payroll payroll) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Payroll Details - ${payroll.employeeName}'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
                              _buildDetailRow('Period', DateFormat('MMMM yyyy').format(DateTime(payroll.year, payroll.month))),
              _buildDetailRow('Status', payroll.status.toUpperCase()),
              _buildDetailRow('Basic Salary', _formatCurrency(payroll.basicSalary)),
              _buildDetailRow('Gross Salary', _formatCurrency(payroll.grossSalary)),
              _buildDetailRow('Net Salary', _formatCurrency(payroll.netSalary), isTotal: true),
              if (payroll.paymentDate != null) ...[
                const SizedBox(height: 8),
                _buildDetailRow('Payment Date', DateFormat('MMM dd, yyyy').format(payroll.paymentDate!)),
              ],
              if (payroll.paymentMethod.isNotEmpty) ...[
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

  Future<void> _loadAllBankAccountsOnce(List<EmployeeEntity> employees) async {
    // Only load if not already loaded
    if (employeeBankAccounts.isNotEmpty) return;
    
    try {
      // Load bank accounts for all employees in parallel
      final futures = employees
          .where((employee) => employee.employeeId != null)
          .map((employee) async {
        try {
          final bankAccounts = await getIt<GetBankAccountsByEmployee>().call(employee.employeeId!);
          return MapEntry(employee.employeeId!, bankAccounts);
        } catch (e) {
          // If one employee fails, continue with others
          print('Failed to load bank accounts for employee ${employee.employeeId}: $e');
          return MapEntry(employee.employeeId!, <BankAccount>[]);
        }
      });
      
      final results = await Future.wait(futures);
      
      if (mounted) {
        setState(() {
          employeeBankAccounts.addAll(Map.fromEntries(results));
        });
      }
    } catch (e) {
      if (mounted) {
        print('Failed to load bank accounts: $e');
      }
    }
  }

  Future<void> _loadAllBankAccounts(List<EmployeeEntity> employees) async {
    // Only load if not already loaded
    if (employeeBankAccounts.isNotEmpty) return;
    
    setState(() {
      isLoadingBankAccounts = true;
    });
    
    try {
      // Load bank accounts for all employees in parallel
      final futures = employees
          .where((employee) => employee.employeeId != null)
          .map((employee) async {
        try {
          final bankAccounts = await getIt<GetBankAccountsByEmployee>().call(employee.employeeId!);
          return MapEntry(employee.employeeId!, bankAccounts);
        } catch (e) {
          // If one employee fails, continue with others
          print('Failed to load bank accounts for employee ${employee.employeeId}: $e');
          return MapEntry(employee.employeeId!, <BankAccount>[]);
        }
      });
      
      final results = await Future.wait(futures);
      
      if (mounted) {
        setState(() {
          employeeBankAccounts.addAll(Map.fromEntries(results));
        });
      }
    } catch (e) {
      if (mounted) {
        print('Failed to load bank accounts: $e');
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoadingBankAccounts = false;
        });
      }
    }
  }

  Future<void> _loadBankAccounts(EmployeeEntity employee) async {
    if (employee.employeeId == null) return;
    
    setState(() {
      isLoadingBankAccounts = true;
    });
    
    try {
      final bankAccounts = await getIt<GetBankAccountsByEmployee>().call(employee.employeeId!);
      if (mounted) {
        setState(() {
          employeeBankAccounts[employee.employeeId!] = bankAccounts;
        });
      }
    } catch (e) {
      if (mounted) {
        context.showErrorSnackBar('Failed to load bank accounts: $e');
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoadingBankAccounts = false;
        });
      }
    }
  }

  double _calculateAverageSalary(List<Salary> salaries) {
    final activeSalaries = salaries.where((salary) => salary.status == 'active').toList();
    if (activeSalaries.isEmpty) return 0.0;
    
    final total = activeSalaries.fold(0.0, (sum, salary) => sum + salary.netSalary);
    return total / activeSalaries.length;
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

  Widget _buildDetailRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
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

  String _formatCurrency(double amount) {
    return amount.currency;
  }
} 