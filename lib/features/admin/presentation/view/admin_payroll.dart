import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hready/app/service_locator/service_locator.dart';
import '../../../payroll/presentation/view_model/payroll_bloc.dart';
import '../../../payroll/presentation/view_model/payroll_event.dart';
import '../../../payroll/presentation/view_model/payroll_state.dart';
import 'package:hready/features/payroll/data/repositories/payroll_remote_repository.dart';
import 'package:hready/features/payroll/data/datasources/remote_datasource/payroll_remote_data_source.dart';
import 'package:dio/dio.dart';

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

  void _onFilterChanged(BuildContext context) {
    context.read<PayrollBloc>().add(
      LoadPayrolls(month: selectedMonth, year: selectedYear, status: selectedStatus.isEmpty ? null : selectedStatus),
    );
    context.read<PayrollBloc>().add(
      LoadPayrollStats(year: selectedYear),
    );
  }

  Future<void> _showGeneratePayrollDialog(BuildContext context) async {
    int genMonth = selectedMonth;
    int genYear = selectedYear;
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Generate Payroll'),
        content: Row(
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
        await context.read<PayrollBloc>().repository.generatePayroll(month: genMonth, year: genYear);
        _onFilterChanged(context);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Payroll generated successfully!')));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to generate payroll: $e')));
      } finally {
        setState(() => isGenerating = false);
      }
    }
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
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocBuilder<PayrollBloc, PayrollState>(
                builder: (context, state) {
                  if (state is PayrollStatsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is PayrollStatsError) {
                    return Center(child: Text('Error loading stats: ${state.message}'));
                  } else if (state is PayrollStatsLoaded) {
                    final stats = state.stats;
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: _InfoCard(
                            title: 'Total Payrolls',
                            value: stats['monthlyStats'] != null && stats['monthlyStats'].isNotEmpty
                                ? stats['monthlyStats'].fold<int>(0, (sum, s) => sum + (s['totalPayrolls'] ?? 0))
                                : 0,
                          ),
                        ),
                        Flexible(
                          child: _InfoCard(
                            title: 'Total Gross',
                            value: stats['monthlyStats'] != null && stats['monthlyStats'].isNotEmpty
                                ? stats['monthlyStats'].fold<double>(0, (sum, s) => sum + (s['totalGrossSalary'] ?? 0.0))
                                : 0.0,
                          ),
                        ),
                        Flexible(
                          child: _InfoCard(
                            title: 'Total Net',
                            value: stats['monthlyStats'] != null && stats['monthlyStats'].isNotEmpty
                                ? stats['monthlyStats'].fold<double>(0, (sum, s) => sum + (s['totalNetSalary'] ?? 0.0))
                                : 0.0,
                          ),
                        ),
                      ],
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
              const SizedBox(height: 24),
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
                  ),
                  const Spacer(),
                  ElevatedButton.icon(
                    icon: isGenerating ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.add),
                    label: const Text('Generate Payroll'),
                    onPressed: isGenerating ? null : () => _showGeneratePayrollDialog(context),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.check_circle_outline),
                    label: const Text('Bulk Approve'),
                    onPressed: () async {
                      final confirmed = await showDialog<bool>(
                        context: context,
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
                          final bloc = context.read<PayrollBloc>();
                          final state = bloc.state;
                          if (state is PayrollLoaded) {
                            final drafts = state.payrolls.where((p) => p.status == 'draft').toList();
                            for (final p in drafts) {
                              await bloc.repository.approvePayroll(p.id);
                            }
                            _onFilterChanged(context);
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('All draft payrolls approved!')));
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to bulk approve: $e')));
                        }
                      }
                    },
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.payments),
                    label: const Text('Bulk Mark as Paid'),
                    onPressed: () async {
                      final confirmed = await showDialog<bool>(
                        context: context,
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
                          final bloc = context.read<PayrollBloc>();
                          final state = bloc.state;
                          if (state is PayrollLoaded) {
                            final approved = state.payrolls.where((p) => p.status == 'approved').toList();
                            for (final p in approved) {
                              await bloc.repository.markPayrollAsPaid(p.id);
                            }
                            _onFilterChanged(context);
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('All approved payrolls marked as paid!')));
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to bulk mark as paid: $e')));
                        }
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
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