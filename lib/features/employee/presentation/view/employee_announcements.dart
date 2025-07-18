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
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Announcements', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    SizedBox(height: 16),
                    state.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : state.error != null
                            ? Center(child: Text('Error: ${state.error}'))
                            : state.announcements.isEmpty
                                ? Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: const [
                                        Icon(Icons.campaign, size: 80, color: Colors.grey),
                                        SizedBox(height: 16),
                                        Text('No announcements yet!', style: TextStyle(color: Colors.grey, fontSize: 18)),
                                      ],
                                    ),
                                  )
                                : Expanded(
                                    child: ListView.separated(
                                      padding: EdgeInsets.zero,
                                      itemCount: state.announcements.length,
                                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                                      itemBuilder: (context, index) {
                                        return _AnnouncementCard(announcement: state.announcements[index]);
                                      },
                                    ),
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

class _AnnouncementCard extends StatefulWidget {
  final dynamic announcement;
  const _AnnouncementCard({required this.announcement});

  @override
  State<_AnnouncementCard> createState() => _AnnouncementCardState();
}

class _AnnouncementCardState extends State<_AnnouncementCard> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    final ann = widget.announcement;
    final maxLines = expanded ? null : 3;
    final isLong = (ann.message?.length ?? 0) > 120;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ann.title ?? '',
                        style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: Colors.black87),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.person, size: 16, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(
                            ann.postedBy ?? 'Admin',
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black54),
                          ),
                          const SizedBox(width: 10),
                          Icon(Icons.access_time, size: 15, color: Colors.grey[600]),
                          const SizedBox(width: 2),
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
                ),
              ],
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: isLong ? () => setState(() => expanded = !expanded) : null,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ann.message ?? '',
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                    maxLines: maxLines,
                    overflow: expanded ? TextOverflow.visible : TextOverflow.ellipsis,
                  ),
                  if (isLong)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        expanded ? 'Show less' : 'Read more',
                        style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.w500, fontSize: 14),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
