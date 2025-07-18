import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hready/features/leaves/presentation/view_model/leave_bloc.dart';
import 'package:hready/features/leaves/domain/entities/leave_entity.dart';
import 'package:hready/app/service_locator/service_locator.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';

class EmployeeLeave extends StatefulWidget {
  const EmployeeLeave({super.key});

  @override
  State<EmployeeLeave> createState() => _EmployeeLeaveState();
}

class _EmployeeLeaveState extends State<EmployeeLeave> {
  final _formKey = GlobalKey<FormState>();
  String? _leaveType;
  DateTime? _startDate;
  DateTime? _endDate;
  String? _reason;
  bool _halfDay = false;
  String? _attachmentPath;
  bool _loading = false;

  void _pickAttachment() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      setState(() {
        _attachmentPath = result.files.single.path;
      });
    }
  }

  void _submit(BuildContext context) {
    if (!_formKey.currentState!.validate() || _leaveType == null || _startDate == null || _endDate == null) return;
    _formKey.currentState!.save();
    setState(() => _loading = true);
    final leave = LeaveEntity(
      leaveType: _leaveType,
      startDate: _startDate,
      endDate: _endDate,
      reason: _reason,
      halfDay: _halfDay,
      attachment: _attachmentPath,
    );
    context.read<LeaveBloc>().add(CreateMyLeave(leave));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<LeaveBloc>()..add(LoadMyLeaves()),
      child: BlocConsumer<LeaveBloc, LeaveState>(
        listener: (context, state) {
          if (state is LeaveError) {
            setState(() => _loading = false);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error)));
          } else if (state is LeaveLoaded) {
            setState(() => _loading = false);
            // Optionally clear form
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Request Leave', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              DropdownButtonFormField<String>(
                                value: _leaveType,
                                items: const [
                                  DropdownMenuItem(value: 'Casual', child: Text('Casual')),
                                  DropdownMenuItem(value: 'Sick', child: Text('Sick')),
                                  DropdownMenuItem(value: 'Emergency', child: Text('Emergency')),
                                  DropdownMenuItem(value: 'Annual', child: Text('Annual')),
                                  DropdownMenuItem(value: 'Other', child: Text('Other')),
                                ],
                                onChanged: (v) => setState(() => _leaveType = v),
                                decoration: const InputDecoration(labelText: 'Leave Type', border: OutlineInputBorder()),
                                validator: (v) => v == null ? 'Select leave type' : null,
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: () async {
                                        final picked = await showDatePicker(
                                          context: context,
                                          initialDate: _startDate ?? DateTime.now(),
                                          firstDate: DateTime(2020),
                                          lastDate: DateTime(2100),
                                        );
                                        if (picked != null) setState(() => _startDate = picked);
                                      },
                                      child: InputDecorator(
                                        decoration: const InputDecoration(labelText: 'Start Date', border: OutlineInputBorder()),
                                        child: Text(_startDate != null ? DateFormat('yyyy-MM-dd').format(_startDate!) : 'Select'),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: InkWell(
                                      onTap: () async {
                                        final picked = await showDatePicker(
                                          context: context,
                                          initialDate: _endDate ?? DateTime.now(),
                                          firstDate: DateTime(2020),
                                          lastDate: DateTime(2100),
                                        );
                                        if (picked != null) setState(() => _endDate = picked);
                                      },
                                      child: InputDecorator(
                                        decoration: const InputDecoration(labelText: 'End Date', border: OutlineInputBorder()),
                                        child: Text(_endDate != null ? DateFormat('yyyy-MM-dd').format(_endDate!) : 'Select'),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              TextFormField(
                                decoration: const InputDecoration(labelText: 'Reason', border: OutlineInputBorder()),
                                maxLines: 2,
                                onSaved: (v) => _reason = v,
                                validator: (v) => v == null || v.isEmpty ? 'Enter reason' : null,
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Checkbox(value: _halfDay, onChanged: (v) => setState(() => _halfDay = v ?? false)),
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
                              const SizedBox(height: 12),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: _loading ? null : () => _submit(context),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF042F46),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    minimumSize: const Size(double.infinity, 48),
                                  ),
                                  child: Text(_loading ? 'Submitting...' : 'Request Leave'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text('Your Leave Records', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    if (state is LeaveLoading)
                      const Center(child: CircularProgressIndicator()),
                    if (state is LeaveLoaded)
                      state.leaves.isEmpty
                        ? const Center(child: Text('No leave records found.', style: TextStyle(color: Colors.grey)))
                        : ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: state.leaves.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final leave = state.leaves[index];
                              return Card(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                elevation: 1,
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Chip(
                                            label: Text(leave.status ?? 'Pending', style: const TextStyle(color: Colors.white)),
                                            backgroundColor: (leave.status == 'Approved')
                                              ? Colors.green
                                              : (leave.status == 'Rejected')
                                                ? Colors.red
                                                : Colors.orange,
                                          ),
                                          const Spacer(),
                                          if (leave.attachment != null && leave.attachment!.isNotEmpty)
                                            IconButton(
                                              icon: const Icon(Icons.attach_file, color: Colors.blue),
                                              onPressed: () {
                                                // TODO: Implement file open/download
                                              },
                                            ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Text('Type: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                          Text(leave.leaveType ?? '-')
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text('Dates: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                          Text(leave.startDate != null ? DateFormat('yyyy-MM-dd').format(leave.startDate!) : '-'),
                                          const Text(' to '),
                                          Text(leave.endDate != null ? DateFormat('yyyy-MM-dd').format(leave.endDate!) : '-')
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text('Half Day: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                          Text(leave.halfDay == true ? 'Yes' : 'No')
                                        ],
                                      ),
                                      if (leave.reason != null && leave.reason!.isNotEmpty)
                                        Row(
                                          children: [
                                            Text('Reason: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                            Expanded(child: Text(leave.reason!)),
                                          ],
                                        ),
                                      if (leave.adminComment != null && leave.adminComment!.isNotEmpty)
                                        Row(
                                          children: [
                                            Text('Comment: ', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                                            Expanded(child: Text(leave.adminComment!, style: const TextStyle(color: Colors.blue))),
                                          ],
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
