import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hready/features/requests/presentation/viewmodel/requests_bloc.dart';
import 'package:hready/features/requests/presentation/viewmodel/requests_event.dart';
import 'package:hready/features/requests/presentation/viewmodel/requests_state.dart';
import 'package:hready/app/service_locator/service_locator.dart';
import 'package:hready/features/requests/domain/use_cases/get_all_requests_use_case.dart';
import 'package:hready/features/requests/domain/use_cases/approve_request_use_case.dart';
import 'package:hready/features/requests/domain/use_cases/reject_request_use_case.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shimmer/shimmer.dart';

class EmployeeRequestsPage extends StatelessWidget {
  const EmployeeRequestsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RequestsBloc(
        getAllRequestsUseCase: getIt<GetAllRequestsUseCase>(),
        approveRequestUseCase: getIt<ApproveRequestUseCase>(),
        rejectRequestUseCase: getIt<RejectRequestUseCase>(),
      )..add(LoadMyRequests()),
      child: BlocBuilder<RequestsBloc, RequestsState>(
        builder: (context, state) {
          return Scaffold(
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    String title = '';
                    String message = '';
                    String type = state.formType;
                    File? attachment;
                    bool isSubmitting = false;
                    String? error;
                    return StatefulBuilder(
                      builder: (context, setState) {
                        return AlertDialog(
                          title: const Text('New Request/Report'),
                          content: SizedBox(
                            width: 500,
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Title', style: TextStyle(fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 8),
                                  TextField(
                                    decoration: const InputDecoration(
                                      hintText: 'Enter a title',
                                      border: OutlineInputBorder(),
                                    ),
                                    onChanged: (val) => title = val,
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    children: [
                                      const Text('Type:', style: TextStyle(fontWeight: FontWeight.bold)),
                                      const SizedBox(width: 12),
                                      DropdownButton<String>(
                                        value: type,
                                        items: const [
                                          DropdownMenuItem(value: 'request', child: Text('Request')),
                                          DropdownMenuItem(value: 'report', child: Text('Report')),
                                        ],
                                        onChanged: (val) => setState(() => type = val ?? 'request'),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  const Text('Message', style: TextStyle(fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 8),
                                  TextField(
                                    decoration: const InputDecoration(
                                      hintText: 'Describe your request or report',
                                      border: OutlineInputBorder(),
                                    ),
                                    maxLines: 3,
                                    onChanged: (val) => message = val,
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(attachment?.path.split('/').last ?? 'No file selected'),
                                      ),
                                      ElevatedButton.icon(
                                        onPressed: () async {
                                          FilePickerResult? result = await FilePicker.platform.pickFiles();
                                          if (result != null && result.files.single.path != null) {
                                            setState(() => attachment = File(result.files.single.path!));
                                          }
                                        },
                                        icon: const Icon(Icons.attach_file),
                                        label: const Text('Attach File'),
                                      ),
                                    ],
                                  ),
                                  if (error != null)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(error!, style: const TextStyle(color: Colors.red)),
                                    ),
                                ],
                              ),
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: isSubmitting
                                  ? null
                                  : () async {
                                      setState(() => isSubmitting = true);
                                      context.read<RequestsBloc>().add(SubmitRequest(
                                            title: title,
                                            message: message,
                                            type: type,
                                            attachment: attachment,
                                          ));
                                      await Future.delayed(const Duration(milliseconds: 500));
                                      setState(() => isSubmitting = false);
                                      Navigator.pop(context);
                                    },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              child: isSubmitting ? const Text('Sending...') : const Text('Send'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('New Request'),
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      const Text('Requests & Reports', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 18),
                      const Divider(height: 1, thickness: 1),
                      const SizedBox(height: 24),
                      const Text('My Requests', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                      const SizedBox(height: 16),
                      Builder(
                        builder: (context) {
                          if (state.isLoading) {
                            return ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: 4,
                              separatorBuilder: (_, __) => const SizedBox(height: 16),
                              itemBuilder: (context, index) => Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Card(
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(height: 16, width: 120, color: Colors.white),
                                        const SizedBox(height: 8),
                                        Container(height: 12, width: 80, color: Colors.white),
                                        const SizedBox(height: 8),
                                        Container(height: 12, width: 180, color: Colors.white),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          } else if (state.error != null && state.requests.isEmpty) {
                            return Center(child: Text('Error: ${state.error!}', style: TextStyle(color: Colors.red)));
                          } else if (state.requests.isEmpty) {
                            return const Center(child: Text('No requests yet.'));
                          }
                          return ListView.separated(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: state.requests.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 16),
                            itemBuilder: (context, index) {
                              final r = state.requests[index];
                              return Card(
                                elevation: 2,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(r.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16), overflow: TextOverflow.ellipsis),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: _statusColor(r.status).withOpacity(0.15),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              r.status,
                                              style: TextStyle(color: _statusColor(r.status), fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Icon(r.type == 'report' ? Icons.report : Icons.request_page, size: 18, color: Colors.blueGrey),
                                          const SizedBox(width: 6),
                                          Text(r.type, style: const TextStyle(fontWeight: FontWeight.w500)),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 4.0),
                                        child: Text(r.message),
                                      ),
                                      if (r.attachment != null)
                                        Padding(
                                          padding: const EdgeInsets.only(top: 4.0),
                                          child: InkWell(
                                            onTap: () {
                                              // TODO: Implement file open/download
                                            },
                                            child: Text(
                                              'Attachment',
                                              style: TextStyle(color: Theme.of(context).primaryColor, decoration: TextDecoration.underline),
                                            ),
                                          ),
                                        ),
                                      if (r.adminComment != null)
                                        Padding(
                                          padding: const EdgeInsets.only(top: 4.0),
                                          child: Text('Admin: ${r.adminComment}', style: const TextStyle(fontStyle: FontStyle.italic)),
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

Color _statusColor(String status) {
  switch (status.toLowerCase()) {
    case 'approved':
      return Colors.green;
    case 'rejected':
      return Colors.red;
    case 'pending':
      return Colors.orange;
    default:
      return Colors.grey;
  }
} 