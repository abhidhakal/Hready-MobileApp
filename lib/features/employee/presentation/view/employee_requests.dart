import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hready/features/requests/presentation/view_model/requests_bloc.dart';
import 'package:hready/features/requests/presentation/view_model/requests_event.dart';
import 'package:hready/features/requests/presentation/view_model/requests_state.dart';
import 'package:hready/app/service_locator/service_locator.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shimmer/shimmer.dart';
import 'package:hready/core/utils/common_snackbar.dart';

class EmployeeRequestsPage extends StatefulWidget {
  const EmployeeRequestsPage({Key? key}) : super(key: key);

  @override
  State<EmployeeRequestsPage> createState() => _EmployeeRequestsPageState();
}

class _EmployeeRequestsPageState extends State<EmployeeRequestsPage> {
  String title = '';
  String message = '';
  String type = 'request';
  File? attachment;

  void _showRequestDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return BlocListener<RequestsBloc, RequestsState>(
          listener: (context, state) {
            if (!state.isSubmitting && state.error == null) {
              // Success - close dialog and show success message
              Navigator.pop(context);
              showCommonSnackbar(context, 'Request submitted successfully!');
            } else if (!state.isSubmitting && state.error != null) {
              // Error - show error message
              showCommonSnackbar(context, 'Error: ${state.error!}');
            }
          },
          child: AlertDialog(
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
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              BlocBuilder<RequestsBloc, RequestsState>(
                builder: (context, state) {
                  return ElevatedButton(
                    onPressed: state.isSubmitting
                        ? null
                        : () {
                            if (title.trim().isEmpty) {
                              showCommonSnackbar(context, 'Please enter a title');
                              return;
                            }
                            if (message.trim().isEmpty) {
                              showCommonSnackbar(context, 'Please enter a message');
                              return;
                            }
                            
                            context.read<RequestsBloc>().add(SubmitRequest(
                                  title: title.trim(),
                                  message: message.trim(),
                                  type: type,
                                  attachment: attachment,
                                ));
                          },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    child: state.isSubmitting 
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Send'),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<RequestsBloc>()..add(LoadMyRequests()),
      child: BlocListener<RequestsBloc, RequestsState>(
        listener: (context, state) {
          if (!state.isSubmitting && state.error == null && state.requests.isNotEmpty) {
            // Success - show success message
            showCommonSnackbar(context, 'Request submitted successfully!');
          } else if (!state.isSubmitting && state.error != null) {
            // Error - show error message
            showCommonSnackbar(context, 'Error: ${state.error!}');
          }
        },
        child: BlocBuilder<RequestsBloc, RequestsState>(
          builder: (context, state) {
            return Scaffold(
            appBar: AppBar(
              title: const Text('Requests & Reports'),
              backgroundColor: const Color(0xFFF5F5F5),
              foregroundColor: Colors.black,
              centerTitle: false,
              elevation: 0,
            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () {
                _showRequestDialog(context);
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
    ));
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