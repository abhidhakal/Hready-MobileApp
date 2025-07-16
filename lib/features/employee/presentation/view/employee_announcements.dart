import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hready/app/service_locator/service_locator.dart';
import 'package:hready/features/announcements/presentation/view_model/announcement_view_model.dart';
import 'package:intl/intl.dart';

class EmployeeAnnouncements extends StatelessWidget {
  const EmployeeAnnouncements({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AnnouncementViewModel>(
      create: (_) => getIt<AnnouncementViewModel>()..loadAnnouncements(),
      child: Consumer<AnnouncementViewModel>(
        builder: (context, vm, _) {
          final state = vm.state;
          return Scaffold(
            body: state.isLoading
                ? const Center(child: CircularProgressIndicator())
                : state.error != null
                    ? Center(child: Text('Error: ${state.error}'))
                    : state.announcements.isEmpty
                        ? const Center(child: Text('No announcements available.'))
                        : ListView.separated(
                            padding: const EdgeInsets.all(16),
                            itemCount: state.announcements.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 16),
                            itemBuilder: (context, index) {
                              final ann = state.announcements[index];
                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.grey[300]!),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      ann.title ?? '',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      ann.message ?? '',
                                      style: const TextStyle(fontSize: 16, color: Colors.black87),
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        Text(
                                          'Posted by: ',
                                          style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                                        ),
                                        Text(
                                          (ann.postedBy ?? 'Admin'),
                                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          ann.createdAt != null
                                              ? DateFormat('yyyy-MM-dd hh:mm a').format(ann.createdAt!)
                                              : '',
                                          style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
          );
        },
      ),
    );
  }
}
