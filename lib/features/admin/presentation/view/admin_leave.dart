import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hready/app/service_locator/service_locator.dart';
import 'package:hready/features/leaves/presentation/view_model/leave_bloc.dart';
import 'package:hready/features/leaves/domain/entities/leave_entity.dart';
import 'package:intl/intl.dart';

class AdminLeave extends StatefulWidget {
  const AdminLeave({super.key});

  @override
  State<AdminLeave> createState() => _AdminLeaveState();
}

class _AdminLeaveState extends State<AdminLeave> {
  final _formKey = GlobalKey<FormState>();
  String leaveType = '';
  DateTime? startDate;
  DateTime? endDate;
  String reason = '';
  bool halfDay = false;

  void _resetForm() {
    leaveType = '';
    startDate = null;
    endDate = null;
    reason = '';
    halfDay = false;
  }

  void _showLeaveFormDialog(BuildContext context) {
    _resetForm();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Request Leave for Myself'),
          content: SizedBox(
            width: 500,
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<String>(
                      value: leaveType.isEmpty ? null : leaveType,
                      items: const [
                        DropdownMenuItem(value: 'Casual', child: Text('Casual')),
                        DropdownMenuItem(value: 'Sick', child: Text('Sick')),
                        DropdownMenuItem(value: 'Emergency', child: Text('Emergency')),
                        DropdownMenuItem(value: 'Annual', child: Text('Annual')),
                        DropdownMenuItem(value: 'Other', child: Text('Other')),
                      ],
                      onChanged: (v) => setState(() => leaveType = v ?? ''),
                      decoration: const InputDecoration(labelText: 'Leave Type'),
                      validator: (v) => v == null || v.isEmpty ? 'Select leave type' : null,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: InputDatePickerFormField(
                            initialDate: startDate ?? DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2100),
                            fieldLabelText: 'Start Date',
                            onDateSubmitted: (date) => setState(() => startDate = date),
                            onDateSaved: (date) => setState(() => startDate = date),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: InputDatePickerFormField(
                            initialDate: endDate ?? DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2100),
                            fieldLabelText: 'End Date',
                            onDateSubmitted: (date) => setState(() => endDate = date),
                            onDateSaved: (date) => setState(() => endDate = date),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Reason'),
                      onChanged: (v) => setState(() => reason = v),
                      validator: (v) => v == null || v.isEmpty ? 'Reason required' : null,
                    ),
                    const SizedBox(height: 12),
                    CheckboxListTile(
                      value: halfDay,
                      onChanged: (v) => setState(() => halfDay = v ?? false),
                      title: const Text('Half Day'),
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    const SizedBox(height: 12),
                    // File upload can be a TODO
                    const Text('Attachment (optional):'),
                    const SizedBox(height: 4),
                    ElevatedButton(
                      onPressed: () {
                        // TODO: File picker for attachment
                      },
                      child: const Text('Upload File'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  final leave = LeaveEntity(
                    leaveType: leaveType,
                    startDate: startDate,
                    endDate: endDate,
                    reason: reason,
                    halfDay: halfDay,
                    // attachment: ...
                    status: 'Pending',
                  );
                  context.read<LeaveBloc>().add(CreateLeave(leave));
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Submit Leave'),
            ),
          ],
        );
      },
    );
  }

  Color _statusColor(String? status) {
    switch (status) {
      case 'Approved':
        return Colors.green;
      case 'Rejected':
        return Colors.red;
      case 'Pending':
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LeaveBloc>(
      create: (_) => getIt<LeaveBloc>()..add(LoadLeaves()),
      child: BlocBuilder<LeaveBloc, LeaveState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('All Leave Requests'),
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
            ),
            body: state is LeaveLoading
                ? const Center(child: CircularProgressIndicator())
                : state is LeaveError
                    ? Center(child: Text('Error: ${state.error}'))
                    : SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (state is LeaveLoaded && state.leaves.isNotEmpty)
                              ...state.leaves.map((leave) => Card(
                                margin: const EdgeInsets.symmetric(vertical: 10),
                                elevation: 3,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                child: Padding(
                                  padding: const EdgeInsets.all(18),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          // 1. Remove the 'Employee' label and just show the name
                                          Text(leave.requestedBy ?? '-', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                                          Chip(
                                            label: Text(leave.status ?? '-'),
                                            backgroundColor: _statusColor(leave.status),
                                            labelStyle: const TextStyle(color: Colors.white),
                                          ),
                                        ],
                                      ),
                                      const Divider(height: 20),
                                      Row(
                                        children: [
                                          Expanded(child: Text('Type: ${leave.leaveType ?? '-'}')),
                                          Expanded(child: Text('Half Day: ${leave.halfDay == true ? 'Yes' : 'No'}')),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          Expanded(child: Text('Start: ${leave.startDate != null ? DateFormat('yyyy-MM-dd').format(leave.startDate!) : '-'}')),
                                          Expanded(child: Text('End: ${leave.endDate != null ? DateFormat('yyyy-MM-dd').format(leave.endDate!) : '-'}')),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      Text('Reason:', style: TextStyle(fontWeight: FontWeight.bold)),
                                      Text(leave.reason ?? '-'),
                                      const SizedBox(height: 6),
                                      if (leave.attachment != null)
                                        TextButton(
                                          onPressed: () {
                                            // TODO: Open/download attachment
                                          },
                                          child: const Text('View Attachment'),
                                        ),
                                      const SizedBox(height: 10),
                                      if ((leave.status ?? '').toLowerCase() == 'pending')
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            ElevatedButton(
                                              onPressed: () => context.read<LeaveBloc>().add(ApproveLeave(leave.id!)),
                                              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                                              child: const Text('Approve'),
                                            ),
                                            const SizedBox(width: 10),
                                            ElevatedButton(
                                              onPressed: () => context.read<LeaveBloc>().add(RejectLeave(leave.id!)),
                                              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                              child: const Text('Reject'),
                                            ),
                                          ],
                                        ),
                                    ],
                                  ),
                                ),
                              )),
                            if (state is LeaveLoaded && state.leaves.isEmpty)
                              const Center(child: Text('No leave requests found.')),
                          ],
                        ),
                      ),
            floatingActionButton: FloatingActionButton(
              onPressed: () => _showLeaveFormDialog(context),
              child: const Icon(Icons.add),
              tooltip: 'Request Leave for Myself',
            ),
          );
        },
      ),
    );
  }
}
