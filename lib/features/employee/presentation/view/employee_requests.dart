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
            appBar: AppBar(title: const Text('Request / Report to Admin')),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Form(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    decoration: const InputDecoration(hintText: 'Title'),
                                    initialValue: state.formTitle,
                                    onChanged: (val) => context.read<RequestsBloc>().add(EmployeeFormChanged('title', val)),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                DropdownButton<String>(
                                  value: state.formType,
                                  items: const [
                                    DropdownMenuItem(value: 'request', child: Text('Request')),
                                    DropdownMenuItem(value: 'report', child: Text('Report')),
                                  ],
                                  onChanged: (val) => context.read<RequestsBloc>().add(EmployeeFormChanged('type', val)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              decoration: const InputDecoration(hintText: 'Message'),
                              initialValue: state.formMessage,
                              maxLines: 3,
                              onChanged: (val) => context.read<RequestsBloc>().add(EmployeeFormChanged('message', val)),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(state.formAttachment != null ? (state.formAttachment as File).path.split('/').last : 'No file selected'),
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    FilePickerResult? result = await FilePicker.platform.pickFiles();
                                    if (result != null && result.files.single.path != null) {
                                      context.read<RequestsBloc>().add(EmployeeFormChanged('attachment', File(result.files.single.path!)));
                                    }
                                  },
                                  child: const Text('Attach File'),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: state.isSubmitting
                                  ? null
                                  : () {
                                      context.read<RequestsBloc>().add(SubmitRequest(
                                            title: state.formTitle,
                                            message: state.formMessage,
                                            type: state.formType,
                                            attachment: state.formAttachment,
                                          ));
                                    },
                              child: state.isSubmitting ? const Text('Sending...') : const Text('Send'),
                            ),
                            if (state.error != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(state.error!, style: const TextStyle(color: Colors.red)),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const Divider(height: 32),
                  const Text('My Requests', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 8),
                  Expanded(
                    child: state.requests.isEmpty
                        ? const Center(child: Text('No requests yet.'))
                        : ListView.separated(
                            itemCount: state.requests.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final r = state.requests[index];
                              return Card(
                                elevation: 2,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(r.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: _statusColor(r.status),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Text(r.status, style: const TextStyle(color: Colors.white)),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Text(r.type, style: const TextStyle(fontWeight: FontWeight.w500)),
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
                          ),
                  ),
                ],
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