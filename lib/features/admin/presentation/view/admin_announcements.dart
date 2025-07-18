import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hready/app/service_locator/service_locator.dart';
import 'package:hready/features/announcements/presentation/view_model/announcement_view_model.dart';
import 'package:hready/features/announcements/domain/entities/announcement_entity.dart';

class AdminAnnouncements extends StatelessWidget {
  const AdminAnnouncements({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AnnouncementViewModel>(
      create: (_) => getIt<AnnouncementViewModel>()..loadAnnouncements(),
      child: Consumer<AnnouncementViewModel>(
        builder: (context, vm, _) {
          final state = vm.state;
          return Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () => _showAnnouncementDialog(context, vm),
              child: const Icon(Icons.add),
            ),
            body: state.isLoading
                ? const Center(child: CircularProgressIndicator())
                : state.error != null
                    ? Center(child: Text('Error: ${state.error}'))
                    : ListView.builder(
                        itemCount: state.announcements.length,
                        itemBuilder: (context, index) {
                          final ann = state.announcements[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            elevation: 2,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            child: ListTile(
                              title: Text(ann.title ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 4),
                                  Text(ann.message ?? ''),
                                  const SizedBox(height: 8),
                                  Text('Audience: ${ann.audience ?? 'all'}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () => _showAnnouncementDialog(context, vm, announcement: ann),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () => vm.deleteAnnouncement(ann.id ?? ''),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          );
        },
      ),
    );
  }

  void _showAnnouncementDialog(BuildContext context, AnnouncementViewModel vm, {AnnouncementEntity? announcement}) {
    final titleController = TextEditingController(text: announcement?.title ?? '');
    final messageController = TextEditingController(text: announcement?.message ?? '');
    final audienceController = TextEditingController(text: announcement?.audience ?? 'all');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(announcement == null ? 'Add Announcement' : 'Edit Announcement'),
        content: SizedBox(
          width: 500,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(labelText: 'Title'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: messageController,
                    decoration: const InputDecoration(labelText: 'Message'),
                    minLines: 3,
                    maxLines: 5,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: audienceController.text,
                    items: const [
                      DropdownMenuItem(value: 'all', child: Text('All')),
                      DropdownMenuItem(value: 'employees', child: Text('Employees')),
                      DropdownMenuItem(value: 'management', child: Text('Management')),
                    ],
                    onChanged: (value) {
                      audienceController.text = value ?? 'all';
                    },
                    decoration: const InputDecoration(labelText: 'Audience'),
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
              final entity = AnnouncementEntity(
                id: announcement?.id,
                title: titleController.text,
                message: messageController.text,
                audience: audienceController.text,
                createdAt: announcement?.createdAt ?? DateTime.now(),
              );
              if (announcement == null) {
                vm.addAnnouncement(entity);
              } else {
                vm.updateAnnouncement(announcement.id ?? '', entity);
              }
              Navigator.of(context).pop();
            },
            child: Text(announcement == null ? 'Add' : 'Update'),
          ),
        ],
      ),
    );
  }
}
