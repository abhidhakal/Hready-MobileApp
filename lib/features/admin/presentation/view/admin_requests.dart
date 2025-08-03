import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hready/features/requests/presentation/view_model/requests_bloc.dart';
import 'package:hready/features/requests/presentation/view_model/requests_event.dart';
import 'package:hready/features/requests/presentation/view_model/requests_state.dart';
import 'package:hready/app/service_locator/service_locator.dart';
import 'package:hready/features/requests/domain/use_cases/get_all_requests_use_case.dart';
import 'package:hready/features/requests/domain/use_cases/approve_request_use_case.dart';
import 'package:hready/features/requests/domain/use_cases/reject_request_use_case.dart';
import 'package:shimmer/shimmer.dart';

class AdminRequests extends StatelessWidget {
  const AdminRequests({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RequestsBloc(
        getAllRequestsUseCase: getIt<GetAllRequestsUseCase>(),
        approveRequestUseCase: getIt<ApproveRequestUseCase>(),
        rejectRequestUseCase: getIt<RejectRequestUseCase>(),
      )..add(LoadRequests()),
      child: BlocBuilder<RequestsBloc, RequestsState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('All Employee Requests'),
              backgroundColor: const Color(0xFFF5F5F5),
              foregroundColor: Colors.black,
              centerTitle: false,
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    if (state.isLoading)
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: 4,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) => Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
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
                      ),
                  if (state.error != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(state.error!, style: const TextStyle(color: Colors.red)),
                    ),
                  if (!state.isLoading && state.requests.isEmpty && state.error == null)
                    const Center(child: Text('No requests found.')),
                  if (state.requests.isNotEmpty)
                    Expanded(
                      child: ListView.separated(
                        itemCount: state.requests.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final r = state.requests[index];
                          final action = state.actionState[r.id];
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
                                      Text(
                                        r.title,
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                      ),
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
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('By: ${r.createdBy?.name ?? r.createdBy?.email ?? 'Unknown'}'),
                                      Text('${r.createdAt.toLocal()}'),
                                    ],
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
                                  if (r.status.toLowerCase() == 'pending')
                                    Padding(
                                      padding: const EdgeInsets.only(top: 12.0),
                                      child: action?.mode != null
                                          ? Row(
                                              children: [
                                                Expanded(
                                                  child: TextFormField(
                                                    decoration: const InputDecoration(
                                                      hintText: 'Add a comment (optional)',
                                                      border: OutlineInputBorder(),
                                                      isDense: true,
                                                    ),
                                                    initialValue: action?.comment ?? '',
                                                    onChanged: (val) => context.read<RequestsBloc>().add(ActionCommentChanged(r.id, val)),
                                                    enabled: !state.isLoading,
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: action!.mode == 'approve' ? Colors.green : Colors.red,
                                                  ),
                                                  onPressed: state.isLoading
                                                      ? null
                                                      : () {
                                                          if (action.mode == 'approve') {
                                                            context.read<RequestsBloc>().add(ApproveRequest(r.id, action.comment));
                                                          } else {
                                                            context.read<RequestsBloc>().add(RejectRequest(r.id, action.comment));
                                                          }
                                                        },
                                                  child: state.isLoading
                                                      ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                                                      : Text(action.mode == 'approve' ? 'Approve' : 'Reject'),
                                                ),
                                                const SizedBox(width: 8),
                                                TextButton(
                                                  onPressed: state.isLoading
                                                      ? null
                                                      : () {
                                                          context.read<RequestsBloc>().add(ActionModeChanged(r.id, null));
                                                        },
                                                  child: const Text('Cancel'),
                                                ),
                                              ],
                                            )
                                          : Row(
                                              children: [
                                                ElevatedButton(
                                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                                                  onPressed: state.isLoading
                                                      ? null
                                                      : () => context.read<RequestsBloc>().add(ActionModeChanged(r.id, 'approve')),
                                                  child: const Text('Approve'),
                                                ),
                                                const SizedBox(width: 8),
                                                ElevatedButton(
                                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                                  onPressed: state.isLoading
                                                      ? null
                                                      : () => context.read<RequestsBloc>().add(ActionModeChanged(r.id, 'reject')),
                                                  child: const Text('Reject'),
                                                ),
                                              ],
                                            ),
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