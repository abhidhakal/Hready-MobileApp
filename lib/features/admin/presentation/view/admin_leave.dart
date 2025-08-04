import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hready/app/service_locator/service_locator.dart';
import 'package:hready/features/leaves/presentation/view_model/leave_bloc.dart';
import 'package:hready/features/leaves/domain/entities/leave_entity.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:hready/core/utils/common_snackbar.dart';

class AdminLeave extends StatefulWidget {
  const AdminLeave({Key? key}) : super(key: key);

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
  String? _attachmentPath;
  bool _loading = false;

  void _resetForm() {
    leaveType = '';
    startDate = null;
    endDate = null;
    reason = '';
    halfDay = false;
    _attachmentPath = null;
  }

  void _pickAttachment() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      setState(() {
        _attachmentPath = result.files.single.path;
      });
    }
  }

  void _showLeaveFormDialog(BuildContext context, LeaveBloc leaveBloc) {
    _resetForm();
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Row(
                children: const [
                  Text('Request Leave for Myself'),
                ],
              ),
              content: SizedBox(
                width: 500,
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                          decoration: const InputDecoration(labelText: 'Leave Type', border: OutlineInputBorder()),
                          validator: (v) => v == null || v.isEmpty ? 'Select leave type' : null,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () async {
                                  final picked = await showDatePicker(
                                    context: context,
                                    initialDate: startDate ?? DateTime.now(),
                                    firstDate: DateTime(2020),
                                    lastDate: DateTime(2100),
                                  );
                                  if (picked != null) setState(() => startDate = picked);
                                },
                                child: InputDecorator(
                                  decoration: const InputDecoration(labelText: 'Start Date', border: OutlineInputBorder()),
                                  child: Text(startDate != null ? DateFormat('yyyy-MM-dd').format(startDate!) : 'Select'),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: InkWell(
                                onTap: () async {
                                  final picked = await showDatePicker(
                                    context: context,
                                    initialDate: endDate ?? DateTime.now(),
                                    firstDate: DateTime(2020),
                                    lastDate: DateTime(2100),
                                  );
                                  if (picked != null) setState(() => endDate = picked);
                                },
                                child: InputDecorator(
                                  decoration: const InputDecoration(labelText: 'End Date', border: OutlineInputBorder()),
                                  child: Text(endDate != null ? DateFormat('yyyy-MM-dd').format(endDate!) : 'Select'),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          decoration: const InputDecoration(labelText: 'Reason', border: OutlineInputBorder()),
                          maxLines: 2,
                          onChanged: (v) => setState(() => reason = v),
                          validator: (v) => v == null || v.isEmpty ? 'Reason required' : null,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Checkbox(value: halfDay, onChanged: (v) => setState(() => halfDay = v ?? false)),
                            const Text('Half Day'),
                            const Spacer(),
                            TextButton.icon(
                              onPressed: _pickAttachment,
                              icon: const Icon(Icons.attach_file),
                              label: Text(_attachmentPath != null ? 'Change File' : 'Attach File'),
                            ),
                            if (_attachmentPath != null)
                              const Icon(Icons.check_circle, color: Colors.green, size: 20),
                          ],
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
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                  child: SizedBox(
                    width: 140,
                    child: ElevatedButton(
                      onPressed: _loading
                          ? null
                          : () {
                              if (_formKey.currentState?.validate() ?? false) {
                                setState(() => _loading = true);
                                final leave = LeaveEntity(
                                  leaveType: leaveType,
                                  startDate: startDate,
                                  endDate: endDate,
                                  reason: reason,
                                  halfDay: halfDay,
                                  attachment: _attachmentPath,
                                  status: 'Pending',
                                );
                                leaveBloc.add(CreateLeave(leave));
                                Navigator.of(context).pop();
                                setState(() => _loading = false);
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF042F46),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        minimumSize: const Size(double.infinity, 48),
                      ),
                      child: Text(_loading ? 'Submitting...' : 'Submit Leave'),
                    ),
                  ),
                ),
              ],
            );
          },
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
              backgroundColor: const Color(0xFFF5F5F5),
              foregroundColor: Colors.black,
              centerTitle: false,
            ),
            body: state is LeaveLoading
                ? ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 4,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) => Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(height: 18, width: 120, color: Colors.white),
                              const SizedBox(height: 10),
                              Container(height: 14, width: 80, color: Colors.white),
                              const SizedBox(height: 10),
                              Container(height: 12, width: 180, color: Colors.white),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                : state is LeaveError
                    ? Center(child: Text('Error: ${state.error}'))
                    : SafeArea(
                        child: SingleChildScrollView(
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
                      ),
            floatingActionButton: FloatingActionButton(
              onPressed: () => _showLeaveFormDialog(context, context.read<LeaveBloc>()),
              child: const Icon(Icons.add),
              tooltip: 'Request Leave for Myself',
            ),
          );
        },
      ),
    );
  }
}
