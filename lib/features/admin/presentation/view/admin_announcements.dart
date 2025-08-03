import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hready/app/service_locator/service_locator.dart';
import 'package:hready/features/announcements/presentation/view_model/announcement_view_model.dart';
import 'package:hready/features/announcements/domain/entities/announcement_entity.dart';
import 'package:shimmer/shimmer.dart';

class AdminAnnouncements extends StatelessWidget {
  const AdminAnnouncements({Key? key}) : super(key: key);

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
            appBar: AppBar(
              title: const Text('Announcements'),
              backgroundColor: const Color(0xFFF5F5F5),
              foregroundColor: Colors.black,
              centerTitle: false,
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    state.isLoading
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
                        : state.error != null
                            ? Center(child: Text('Error: ${state.error}'))
                            : state.announcements.isEmpty
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      SizedBox(height: 60),
                                      Icon(Icons.campaign, size: 80, color: Colors.grey),
                                      SizedBox(height: 16),
                                      Text('No announcements yet!', style: TextStyle(color: Colors.grey, fontSize: 18)),
                                    ],
                                  )
                                : ListView.separated(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: state.announcements.length,
                                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                                    itemBuilder: (context, index) {
                                      final ann = state.announcements[index];
                                      final isLong = (ann.message?.length ?? 0) > 120;
                                      return Card(
                                        margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                                        elevation: 3,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(18.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.orange[100],
                                                      borderRadius: BorderRadius.circular(12),
                                                    ),
                                                    padding: const EdgeInsets.all(8),
                                                    child: const Icon(Icons.campaign, color: Colors.orange, size: 28),
                                                  ),
                                                  const SizedBox(width: 12),
                                                  Expanded(
                                                    child: Text(
                                                      ann.title ?? '',
                                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 19, color: Colors.black87),
                                                      maxLines: 2,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  IconButton(
                                                    icon: const Icon(Icons.edit, color: Colors.blueGrey),
                                                    onPressed: () => _showAnnouncementDialog(context, vm, announcement: ann),
                                                  ),
                                                  IconButton(
                                                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                                                    onPressed: () => vm.deleteAnnouncement(ann.id ?? ''),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 8),
                                              Row(
                                                children: [
                                                  Chip(
                                                    label: Text(
                                                      ann.audience ?? 'all',
                                                      style: const TextStyle(fontSize: 12, color: Colors.white),
                                                    ),
                                                    backgroundColor: Colors.blueGrey,
                                                    padding: const EdgeInsets.symmetric(horizontal: 8),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  if (ann.createdAt != null)
                                                    Chip(
                                                      label: Text(
                                                        '${ann.createdAt!.year}-${ann.createdAt!.month.toString().padLeft(2, '0')}-${ann.createdAt!.day.toString().padLeft(2, '0')}',
                                                        style: const TextStyle(fontSize: 12, color: Colors.white),
                                                      ),
                                                      backgroundColor: Colors.teal,
                                                      padding: const EdgeInsets.symmetric(horizontal: 8),
                                                    ),
                                                ],
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                isLong ? (ann.message!.substring(0, 120) + '...') : (ann.message ?? ''),
                                                style: const TextStyle(fontSize: 15),
                                              ),
                                              if (isLong)
                                                TextButton(
                                                  onPressed: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) => AlertDialog(
                                                        title: Text(ann.title ?? ''),
                                                        content: Text(ann.message ?? ''),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () => Navigator.pop(context),
                                                            child: const Text('Close'),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                  child: const Text('Read More'),
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
        title: Row(
          children: [
            Icon(announcement == null ? Icons.add : Icons.edit, color: Colors.orange),
            const SizedBox(width: 8),
            Text(announcement == null ? 'Add Announcement' : 'Edit Announcement'),
          ],
        ),
        content: SizedBox(
          width: 500,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Title', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(labelText: 'Title', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 16),
                  const Text('Message', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: messageController,
                    decoration: const InputDecoration(labelText: 'Message', border: OutlineInputBorder()),
                    minLines: 3,
                    maxLines: 5,
                  ),
                  const SizedBox(height: 16),
                  const Text('Audience', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
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
                    decoration: const InputDecoration(border: OutlineInputBorder()),
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
          ElevatedButton(
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
