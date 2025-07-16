import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hready/app/service_locator/service_locator.dart';
import 'package:hready/features/announcements/presentation/view_model/announcement_view_model.dart';
import 'package:intl/intl.dart';

class AdminHome extends StatelessWidget {
  const AdminHome({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ChangeNotifierProvider<AnnouncementViewModel>(
        create: (_) => getIt<AnnouncementViewModel>()..loadAnnouncements(),
        child: Consumer<AnnouncementViewModel>(
          builder: (context, vm, _) {
            final state = vm.state;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome Banner
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 2,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          CircleAvatar(radius: 32, backgroundImage: AssetImage('assets/images/profile.png')),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Hello, Admin', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Text('Today’s Attendance: '),
                                    Text('Not Done', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Info Cards Row (Overview and Employees only, taller, white)
                  SizedBox(
                    height: 160,
                    child: Row(
                      children: [
                        Expanded(
                          child: _InfoCard(
                            title: 'Today’s Overview',
                            content: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text('Active Employees: 45'),
                                Text('On Leave: 4'),
                                Text('Absent: 9'),
                              ],
                            ),
                            color: Colors.white,
                            height: 160,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _InfoCard(
                            title: 'Total Employees',
                            content: const Text('45', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                            color: Colors.white,
                            height: 160,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Pending Leave Requests card below (full width, button on right)
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 2,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text('Pending Leave Requests', style: TextStyle(fontWeight: FontWeight.bold)),
                              SizedBox(height: 8),
                              Text('4', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const Spacer(),
                          ElevatedButton(
                            onPressed: () {},
                            child: const Text('Review Now'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Recent Tasks
                  const Text('Recent Tasks', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 2,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            children: const [
                              Expanded(child: Text('Task Name', style: TextStyle(fontWeight: FontWeight.bold))),
                              Expanded(child: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
                              Expanded(child: Text('Details', style: TextStyle(fontWeight: FontWeight.bold))),
                            ],
                          ),
                          const Divider(height: 16),
                          for (int i = 0; i < 3; i++)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                children: [
                                  Expanded(child: Text('Task ${i + 1}')),
                                  Expanded(child: Text('Pending', style: TextStyle(color: Colors.orange))),
                                  Expanded(child: TextButton(onPressed: () {}, child: const Text('Details'))),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Recent Announcements
                  const Text('Recent Announcements', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  state.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : state.error != null
                          ? Center(child: Text('Error: ${state.error}'))
                          : state.announcements.isEmpty
                              ? const Center(child: Text('No announcements available.'))
                              : ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: state.announcements.take(5).length,
                                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                                  itemBuilder: (context, index) {
                                    final ann = state.announcements[index];
                                    return Card(
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                      elevation: 2,
                                      color: Colors.white,
                                      child: Padding(
                                        padding: const EdgeInsets.all(16),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(ann.title ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
                                            const SizedBox(height: 4),
                                            Text(
                                              ann.message != null && ann.message!.length > 100
                                                  ? ann.message!.substring(0, 100) + '...'
                                                  : ann.message ?? '',
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              ann.createdAt != null
                                                  ? DateFormat('yyyy-MM-dd').format(ann.createdAt!)
                                                  : '',
                                              style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final Widget content;
  final Color? color;
  final double? height;
  const _InfoCard({required this.title, required this.content, this.color, this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 120,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 2,
        color: color,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              content,
            ],
          ),
        ),
      ),
    );
  }
}
