import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hready/app/service_locator/service_locator.dart';
import '../../../payroll/presentation/view_model/payroll_bloc.dart';
import '../../../payroll/presentation/view_model/payroll_event.dart';
import '../../../payroll/presentation/view_model/payroll_state.dart';
import 'package:hready/features/payroll/data/repositories/payroll_remote_repository.dart';
import 'package:hready/features/payroll/data/datasources/remote_datasource/payroll_remote_data_source.dart';
import 'package:dio/dio.dart';
import 'package:hready/features/payroll/data/repositories/salary_repository.dart';
import 'package:hready/features/payroll/data/datasources/remote_datasource/salary_remote_data_source.dart';
import 'package:hready/features/payroll/data/models/salary_model.dart';

class AdminPayrollPage extends StatefulWidget {
  const AdminPayrollPage({Key? key}) : super(key: key);

  @override
  State<AdminPayrollPage> createState() => _AdminPayrollPageState();
}

class _AdminPayrollPageState extends State<AdminPayrollPage> {
  int selectedMonth = DateTime.now().month;
  int selectedYear = DateTime.now().year;
  String selectedStatus = '';
  bool isGenerating = false;
  int _tabIndex = 0; // 0 = Payrolls, 1 = Salaries, 2 = Employee Payrolls
  late final SalaryRepository salaryRepository;
  List<SalaryModel>? salaries;
  bool isLoadingSalaries = false;
  String? salaryError;
  List<Map<String, dynamic>> employees = [];
  bool isLoadingEmployees = false;
  String? employeeError;
  double? salaryBudget;
  bool isLoadingBudget = false;
  String? budgetError;

  @override
  void initState() {
    super.initState();
    salaryRepository = SalaryRepository(SalaryRemoteDataSource(getIt<Dio>()));
    _fetchSalaries();
    _fetchEmployees();
    _fetchSalaryBudget();
  }

  Future<void> _fetchSalaries() async {
    setState(() {
      isLoadingSalaries = true;
      salaryError = null;
    });
    try {
      final result = await salaryRepository.getAllSalaries();
      setState(() => salaries = result);
    } catch (e) {
      setState(() => salaryError = e.toString());
    } finally {
      setState(() => isLoadingSalaries = false);
    }
  }

  Future<void> _fetchEmployees() async {
    setState(() {
      isLoadingEmployees = true;
      employeeError = null;
    });
    try {
      final dio = getIt<Dio>();
      final response = await dio.get('/employees');
      final data = response.data as List;
      setState(() {
        employees = data.map((e) => {
          'id': e['_id'] ?? '',
          'name': e['name'] ?? '',
          'email': e['email'] ?? '',
          'department': e['department'] ?? '',
          'position': e['position'] ?? '',
        }).toList();
      });
    } catch (e) {
      setState(() => employeeError = e.toString());
    } finally {
      setState(() => isLoadingEmployees = false);
    }
  }

  Future<void> _fetchSalaryBudget() async {
    setState(() {
      isLoadingBudget = true;
      budgetError = null;
    });
    try {
      final dio = getIt<Dio>();
      final response = await dio.get('/payroll-settings/payroll-budget');
      setState(() => salaryBudget = (response.data['budget'] as num?)?.toDouble());
    } catch (e) {
      setState(() => budgetError = e.toString());
    } finally {
      setState(() => isLoadingBudget = false);
    }
  }

  Future<void> _showEmployeePayrollsDialog(String employeeId, String employeeName) async {
    showDialog(
      context: context,
      builder: (ctx) => FutureBuilder(
        future: context.read<PayrollBloc>().repository.getEmployeePayrollHistory(employeeId),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const AlertDialog(content: Center(child: CircularProgressIndicator()));
          }
          if (snapshot.hasError) {
            return AlertDialog(title: Text(employeeName), content: Text('Error: ${snapshot.error}'));
          }
          final payrolls = snapshot.data as List?;
          return AlertDialog(
            title: Text('$employeeName Payrolls'),
            content: SizedBox(
              width: 350,
              child: payrolls == null || payrolls.isEmpty
                  ? const Text('No payrolls found.')
                  : ListView.separated(
                      shrinkWrap: true,
                      itemCount: payrolls.length,
                      separatorBuilder: (_, __) => const Divider(),
                      itemBuilder: (ctx, i) {
                        final p = payrolls[i];
                        return ListTile(
                          title: Text('Month: ${p.month}/${p.year}'),
                          subtitle: Text('Net: ${p.netSalary ?? '-'} | Status: ${p.status ?? '-'}'),
                        );
                      },
                    ),
            ),
            actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close'))],
          );
        },
      ),
    );
  }

  Future<void> _showSettingsModal() async {
    double? budgetInput = salaryBudget;
    bool isSaving = false;
    await showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: const Text('Payroll Settings'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                initialValue: budgetInput?.toString() ?? '',
                decoration: const InputDecoration(labelText: 'Salary Budget'),
                keyboardType: TextInputType.number,
                onChanged: (v) => budgetInput = double.tryParse(v),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: isSaving
                  ? null
                  : () async {
                      setState(() => isSaving = true);
                      try {
                        final dio = getIt<Dio>();
                        await dio.put('/payroll-settings/payroll-budget', data: {'budget': budgetInput});
                        await _fetchSalaryBudget();
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Budget updated!')));
                        Navigator.pop(ctx);
                      } catch (e) {
                        setState(() => isSaving = false);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed: $e')));
                      }
                    },
              child: isSaving ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showBankInfoModal(String employeeId, String employeeName) async {
    bool isLoading = true;
    List<Map<String, dynamic>> accounts = [];
    String? error;
    final dio = getIt<Dio>();
    await showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) {
          if (isLoading) {
            dio.get('/bank-accounts/employee/$employeeId').then((res) {
              setState(() {
                accounts = (res.data as List).cast<Map<String, dynamic>>();
                isLoading = false;
              });
            }).catchError((e) {
              setState(() {
                error = e.toString();
                isLoading = false;
              });
            });
            return const AlertDialog(content: Center(child: CircularProgressIndicator()));
          }
          return AlertDialog(
            title: Text('$employeeName Bank Info'),
            content: error != null
                ? Text('Error: $error')
                : accounts.isEmpty
                    ? const Text('No bank accounts found.')
                    : SizedBox(
                        width: 350,
                        child: ListView.separated(
                          shrinkWrap: true,
                          itemCount: accounts.length,
                          separatorBuilder: (_, __) => const Divider(),
                          itemBuilder: (ctx, i) {
                            final acc = accounts[i];
                            return ListTile(
                              title: Text(acc['bankName'] ?? ''),
                              subtitle: Text('Acc: ${acc['accountNumber'] ?? ''} | Holder: ${acc['accountHolderName'] ?? ''}'),
                            );
                          },
                        ),
                      ),
            actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close'))],
          );
        },
      ),
    );
  }

  void _onFilterChanged(BuildContext context) {
    context.read<PayrollBloc>().add(
      LoadPayrolls(month: selectedMonth, year: selectedYear, status: selectedStatus.isEmpty ? null : selectedStatus),
    );
    context.read<PayrollBloc>().add(
      LoadPayrollStats(year: selectedYear),
    );
  }

  Future<void> _showGeneratePayrollDialog(BuildContext parentContext) async {
    int genMonth = selectedMonth;
    int genYear = selectedYear;
    final result = await showDialog<bool>(
      context: parentContext,
      builder: (ctx) => AlertDialog(
        title: const Text('Generate Payroll'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButton<int>(
                value: genMonth,
                items: List.generate(12, (i) => DropdownMenuItem(
                  value: i + 1,
                  child: Text('${DateTime(0, i + 1).month.toString().padLeft(2, '0')}'),
                )),
                onChanged: (val) => setState(() => genMonth = val!),
              ),
              const SizedBox(width: 12),
              DropdownButton<int>(
                value: genYear,
                items: List.generate(5, (i) {
                  final year = DateTime.now().year - 2 + i;
                  return DropdownMenuItem(value: year, child: Text('$year'));
                }),
                onChanged: (val) => setState(() => genYear = val!),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Generate'),
          ),
        ],
      ),
    );
    if (result == true) {
      setState(() => isGenerating = true);
      try {
        await BlocProvider.of<PayrollBloc>(parentContext).repository.generatePayroll(month: genMonth, year: genYear);
        _onFilterChanged(parentContext);
        ScaffoldMessenger.of(parentContext).showSnackBar(const SnackBar(content: Text('Payroll generated successfully!')));
      } catch (e) {
        ScaffoldMessenger.of(parentContext).showSnackBar(SnackBar(content: Text('Failed to generate payroll: $e')));
      } finally {
        setState(() => isGenerating = false);
      }
    }
  }

  Future<void> _showEditSalaryDialog(SalaryModel? salary) async {
    final _formKey = GlobalKey<FormState>();
    double basicSalary = salary?.basicSalary ?? 0;
    String currency = salary?.currency ?? 'NPR';
    String notes = salary?.notes ?? '';
    bool isSaving = false;
    await showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: Text(salary == null ? 'Add Salary' : 'Edit Salary'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  initialValue: basicSalary > 0 ? basicSalary.toString() : '',
                  decoration: const InputDecoration(labelText: 'Basic Salary'),
                  keyboardType: TextInputType.number,
                  validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                  onChanged: (v) => basicSalary = double.tryParse(v) ?? 0,
                ),
                TextFormField(
                  initialValue: currency,
                  decoration: const InputDecoration(labelText: 'Currency'),
                  onChanged: (v) => currency = v,
                ),
                TextFormField(
                  initialValue: notes,
                  decoration: const InputDecoration(labelText: 'Notes'),
                  onChanged: (v) => notes = v,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: isSaving
                  ? null
                  : () async {
                      if (!_formKey.currentState!.validate()) return;
                      setState(() => isSaving = true);
                      try {
                        if (salary == null) {
                          // Create new salary (requires employeeId)
                          // For demo, just refresh
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Salary creation not implemented.')));
                        } else {
                          await salaryRepository.updateSalary(salary.id, {
                            'basicSalary': basicSalary,
                            'currency': currency,
                            'notes': notes,
                          });
                          await _fetchSalaries();
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Salary updated!')));
                        }
                        Navigator.pop(ctx);
                      } catch (e) {
                        setState(() => isSaving = false);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed: $e')));
                      }
                    },
              child: isSaving ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PayrollBloc(
        PayrollRemoteRepository(
          PayrollRemoteDataSource(getIt<Dio>()),
        ),
      )
        ..add(LoadPayrolls(month: selectedMonth, year: selectedYear, status: null))
        ..add(LoadPayrollStats(year: selectedYear)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Admin Payroll'),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              tooltip: 'Payroll Settings',
              onPressed: _showSettingsModal,
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tab bar
              Row(
                children: [
                  ChoiceChip(
                    label: const Text('Payrolls'),
                    selected: _tabIndex == 0,
                    onSelected: (v) => setState(() => _tabIndex = 0),
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('Salaries'),
                    selected: _tabIndex == 1,
                    onSelected: (v) => setState(() => _tabIndex = 1),
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('Employee Payrolls'),
                    selected: _tabIndex == 2,
                    onSelected: (v) => setState(() => _tabIndex = 2),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (_tabIndex == 0) ...[
                BlocBuilder<PayrollBloc, PayrollState>(
                  builder: (context, state) {
                    if (state is PayrollStatsLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is PayrollStatsError) {
                      return Center(child: Text('Error loading stats: ${state.message}'));
                    } else if (state is PayrollStatsLoaded) {
                      final stats = state.stats;
                      final monthlyStats = (stats['monthlyStats'] ?? []) as List;
                      final totalPayrolls = monthlyStats.fold<int>(0, (sum, s) => sum + ((s['totalPayrolls'] ?? 0) as int));
                      final totalGross = monthlyStats.fold<double>(
                        0.0,
                        (sum, s) => sum + ((s['totalGrossSalary'] ?? 0) as num).toDouble(),
                      );
                      final totalNet = monthlyStats.fold<double>(
                        0.0,
                        (sum, s) => sum + ((s['totalNetSalary'] ?? 0) as num).toDouble(),
                      );
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: _InfoCard(
                              title: 'Total Payrolls',
                              value: totalPayrolls,
                            ),
                          ),
                          Flexible(
                            child: _InfoCard(
                              title: 'Total Gross',
                              value: totalGross,
                            ),
                          ),
                          Flexible(
                            child: _InfoCard(
                              title: 'Total Net',
                              value: totalNet,
                            ),
                          ),
                        ],
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
                // --- Professional Filter & Actions Card ---
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  margin: const EdgeInsets.only(bottom: 24),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Filters Row
                        Row(
                          children: [
                            // Month filter
                            DropdownButton<int>(
                              value: selectedMonth,
                              items: List.generate(12, (i) => DropdownMenuItem(
                                value: i + 1,
                                child: Text('${DateTime(0, i + 1).month.toString().padLeft(2, '0')}'),
                              )),
                              onChanged: (val) {
                                setState(() => selectedMonth = val!);
                                _onFilterChanged(context);
                              },
                            ),
                            const SizedBox(width: 12),
                            // Year filter
                            DropdownButton<int>(
                              value: selectedYear,
                              items: List.generate(5, (i) {
                                final year = DateTime.now().year - 2 + i;
                                return DropdownMenuItem(value: year, child: Text('$year'));
                              }),
                              onChanged: (val) {
                                setState(() => selectedYear = val!);
                                _onFilterChanged(context);
                              },
                            ),
                            const SizedBox(width: 12),
                            // Status filter
                            DropdownButton<String>(
                              value: selectedStatus,
                              items: const [
                                DropdownMenuItem(value: '', child: Text('All Status')),
                                DropdownMenuItem(value: 'draft', child: Text('Draft')),
                                DropdownMenuItem(value: 'approved', child: Text('Approved')),
                                DropdownMenuItem(value: 'paid', child: Text('Paid')),
                                DropdownMenuItem(value: 'cancelled', child: Text('Cancelled')),
                              ],
                              onChanged: (val) {
                                setState(() => selectedStatus = val!);
                                _onFilterChanged(context);
                              },
                            ),
                            const SizedBox(width: 12),
                            IconButton(
                              icon: const Icon(Icons.refresh),
                              onPressed: () => _onFilterChanged(context),
                              tooltip: 'Refresh',
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // Actions Row
                        Builder(
                          builder: (blocContext) => Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton.icon(
                                icon: isGenerating ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.add),
                                label: const Text('Generate Payroll'),
                                style: ElevatedButton.styleFrom(minimumSize: const Size(160, 40)),
                                onPressed: isGenerating ? null : () => _showGeneratePayrollDialog(blocContext),
                              ),
                              const SizedBox(width: 12),
                              ElevatedButton.icon(
                                icon: const Icon(Icons.check_circle_outline),
                                label: const Text('Bulk Approve'),
                                style: ElevatedButton.styleFrom(minimumSize: const Size(140, 40)),
                                onPressed: () async {
                                  final confirmed = await showDialog<bool>(
                                    context: blocContext,
                                    builder: (ctx) => AlertDialog(
                                      title: const Text('Bulk Approve Payrolls'),
                                      content: const Text('Approve all draft payrolls in the current filter?'),
                                      actions: [
                                        TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
                                        ElevatedButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Approve All')),
                                      ],
                                    ),
                                  );
                                  if (confirmed == true) {
                                    try {
                                      // Get all draft payrolls in the current filter
                                      final bloc = BlocProvider.of<PayrollBloc>(blocContext);
                                      final state = bloc.state;
                                      if (state is PayrollLoaded) {
                                        final drafts = state.payrolls.where((p) => p.status == 'draft').toList();
                                        for (final p in drafts) {
                                          await bloc.repository.approvePayroll(p.id);
                                        }
                                        _onFilterChanged(blocContext);
                                        ScaffoldMessenger.of(blocContext).showSnackBar(const SnackBar(content: Text('All draft payrolls approved!')));
                                      }
                                    } catch (e) {
                                      ScaffoldMessenger.of(blocContext).showSnackBar(SnackBar(content: Text('Failed to bulk approve: $e')));
                                    }
                                  }
                                },
                              ),
                              const SizedBox(width: 12),
                              ElevatedButton.icon(
                                icon: const Icon(Icons.payments),
                                label: const Text('Bulk Mark as Paid'),
                                style: ElevatedButton.styleFrom(minimumSize: const Size(170, 40)),
                                onPressed: () async {
                                  final confirmed = await showDialog<bool>(
                                    context: blocContext,
                                    builder: (ctx) => AlertDialog(
                                      title: const Text('Bulk Mark as Paid'),
                                      content: const Text('Mark all approved payrolls in the current filter as paid?'),
                                      actions: [
                                        TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
                                        ElevatedButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Mark All as Paid')),
                                      ],
                                    ),
                                  );
                                  if (confirmed == true) {
                                    try {
                                      final bloc = BlocProvider.of<PayrollBloc>(blocContext);
                                      final state = bloc.state;
                                      if (state is PayrollLoaded) {
                                        final approved = state.payrolls.where((p) => p.status == 'approved').toList();
                                        for (final p in approved) {
                                          await bloc.repository.markPayrollAsPaid(p.id);
                                        }
                                        _onFilterChanged(blocContext);
                                        ScaffoldMessenger.of(blocContext).showSnackBar(const SnackBar(content: Text('All approved payrolls marked as paid!')));
                                      }
                                    } catch (e) {
                                      ScaffoldMessenger.of(blocContext).showSnackBar(SnackBar(content: Text('Failed to bulk mark as paid: $e')));
                                    }
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // --- End Professional Filter & Actions Card ---
                Expanded(
                  child: BlocBuilder<PayrollBloc, PayrollState>(
                    builder: (context, state) {
                      if (state is PayrollLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is PayrollError) {
                        return Center(child: Text('Error: ${state.message}'));
                      } else if (state is PayrollLoaded) {
                        if (state.payrolls.isEmpty) {
                          return const Center(child: Text('No payroll records found.'));
                        }
                        return ListView.separated(
                          itemCount: state.payrolls.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final payroll = state.payrolls[index];
                            return Card(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              elevation: 2,
                              child: ListTile(
                                title: Text(payroll.employeeName),
                                subtitle: Text('Month:  ${payroll.month}/${payroll.year}\nNet Salary:  ${payroll.netSalary ?? '-'}'),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (payroll.status == 'draft')
                                      IconButton(
                                        icon: const Icon(Icons.check, color: Colors.green),
                                        tooltip: 'Approve',
                                        onPressed: () async {
                                          final confirmed = await showDialog<bool>(
                                            context: context,
                                            builder: (ctx) => AlertDialog(
                                              title: const Text('Approve Payroll'),
                                              content: const Text('Are you sure you want to approve this payroll?'),
                                              actions: [
                                                TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
                                                ElevatedButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Approve')),
                                              ],
                                            ),
                                          );
                                          if (confirmed == true) {
                                            try {
                                              await context.read<PayrollBloc>().repository.approvePayroll(payroll.id);
                                              _onFilterChanged(context);
                                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Payroll approved!')));
                                            } catch (e) {
                                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to approve payroll: $e')));
                                            }
                                          }
                                        },
                                      ),
                                    if (payroll.status == 'approved')
                                      IconButton(
                                        icon: const Icon(Icons.payment, color: Colors.blue),
                                        tooltip: 'Mark as Paid',
                                        onPressed: () async {
                                          final confirmed = await showDialog<bool>(
                                            context: context,
                                            builder: (ctx) => AlertDialog(
                                              title: const Text('Mark as Paid'),
                                              content: const Text('Mark this payroll as paid?'),
                                              actions: [
                                                TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
                                                ElevatedButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Mark as Paid')),
                                              ],
                                            ),
                                          );
                                          if (confirmed == true) {
                                            try {
                                              await context.read<PayrollBloc>().repository.markPayrollAsPaid(payroll.id);
                                              _onFilterChanged(context);
                                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Payroll marked as paid!')));
                                            } catch (e) {
                                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to mark as paid: $e')));
                                            }
                                          }
                                        },
                                      ),
                                    IconButton(
                                      icon: const Icon(Icons.remove_red_eye, color: Colors.orange),
                                      tooltip: 'View Details',
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (ctx) => AlertDialog(
                                            title: const Text('Payroll Details'),
                                            content: SingleChildScrollView(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text('Employee: ${payroll.employeeName}'),
                                                  Text('Month/Year: ${payroll.month}/${payroll.year}'),
                                                  Text('Status: ${payroll.status}'),
                                                  Text('Gross Salary: ${payroll.grossSalary ?? '-'}'),
                                                  Text('Net Salary: ${payroll.netSalary ?? '-'}'),
                                                  Text('Allowances: ${payroll.allowances ?? '-'}'),
                                                  Text('Deductions: ${payroll.deductions ?? '-'}'),
                                                  Text('Payment Date: ${payroll.paymentDate ?? '-'}'),
                                                  Text('Payment Method: ${payroll.paymentMethod ?? '-'}'),
                                                  Text('Transaction ID: ${payroll.transactionId ?? '-'}'),
                                                ],
                                              ),
                                            ),
                                            actions: [
                                              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.red),
                                      tooltip: 'Delete Payroll',
                                      onPressed: () async {
                                        final confirmed = await showDialog<bool>(
                                          context: context,
                                          builder: (ctx) => AlertDialog(
                                            title: const Text('Delete Payroll'),
                                            content: const Text('Are you sure you want to delete this payroll?'),
                                            actions: [
                                              TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
                                              ElevatedButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete')),
                                            ],
                                          ),
                                        );
                                        if (confirmed == true) {
                                          try {
                                            await context.read<PayrollBloc>().repository.deletePayroll(payroll.id);
                                            _onFilterChanged(context);
                                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Payroll deleted!')));
                                          } catch (e) {
                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete payroll: $e')));
                                          }
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ] else if (_tabIndex == 1) ...[
                Expanded(
                  child: isLoadingSalaries
                      ? const Center(child: CircularProgressIndicator())
                      : salaryError != null
                          ? Center(child: Text('Error: $salaryError'))
                          : salaries == null
                              ? const SizedBox.shrink()
                              : ListView.separated(
                                  itemCount: salaries!.length,
                                  separatorBuilder: (_, __) => const Divider(),
                                  itemBuilder: (context, index) {
                                    final s = salaries![index];
                                    return ListTile(
                                      title: Text(s.employeeName),
                                      subtitle: Text('Basic Salary: ${s.basicSalary}\nGross: ${s.grossSalary ?? '-'} | Net: ${s.netSalary ?? '-'}'),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.edit, color: Colors.blue),
                                            tooltip: 'Edit Salary',
                                            onPressed: () => _showEditSalaryDialog(s),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                ),
              ] else ...[
                Expanded(
                  child: isLoadingEmployees
                      ? const Center(child: CircularProgressIndicator())
                      : employeeError != null
                          ? Center(child: Text('Error: $employeeError'))
                          : employees.isEmpty
                              ? const Center(child: Text('No employees found.'))
                              : ListView.separated(
                                  itemCount: employees.length,
                                  separatorBuilder: (_, __) => const Divider(),
                                  itemBuilder: (context, index) {
                                    final emp = employees[index];
                                    return ListTile(
                                      title: Text(emp['name'] ?? ''),
                                      subtitle: Text('${emp['email']} | ${emp['department']} | ${emp['position']}'),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.list_alt, color: Colors.blue),
                                            tooltip: 'View Payrolls',
                                            onPressed: () => _showEmployeePayrollsDialog(emp['id']!, emp['name'] ?? ''),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.account_balance, color: Colors.green),
                                            tooltip: 'Bank Info',
                                            onPressed: () => _showBankInfoModal(emp['id']!, emp['name'] ?? ''),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final dynamic value;
  const _InfoCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('$value', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
} 