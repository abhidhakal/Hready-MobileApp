import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hready/features/admin/presentation/viewmodel/admin_profile_bloc.dart';
import 'package:hready/features/admin/presentation/viewmodel/admin_profile_event.dart';
import 'package:hready/features/admin/presentation/viewmodel/admin_profile_state.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shimmer/shimmer.dart';
import 'package:hready/core/utils/common_snackbar.dart';

class AdminProfilePage extends StatelessWidget {
  const AdminProfilePage({Key? key}) : super(key: key);

  String _resolveProfilePicture(String picture) {
    if (picture.isEmpty) return '';
    if (picture.startsWith('/uploads/')) {
      return 'http://192.168.18.175:3000$picture'; // <-- Use your API base URL
    }
    if (picture.startsWith('http')) return picture;
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AdminProfileBloc()..add(LoadAdminProfile()),
      child: BlocListener<AdminProfileBloc, AdminProfileState>(
        listenWhen: (previous, current) =>
            previous.success != current.success || previous.error != current.error,
        listener: (context, state) {
          if (state.success.isNotEmpty) {
            showCommonSnackbar(context, state.success);
          } else if (state.error.isNotEmpty) {
            showCommonSnackbar(context, state.error);
          }
        },
        child: BlocBuilder<AdminProfileBloc, AdminProfileState>(
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Admin Profile'),
                backgroundColor: const Color(0xFFF5F5F5),
                foregroundColor: Colors.black,
                centerTitle: false,
              ),
              body: state.isLoading
                  ? Padding(
                      padding: const EdgeInsets.all(24),
                      child: SizedBox(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Card(
                            elevation: 3,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 120,
                                    height: 120,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(60),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Container(height: 22, width: 120, color: Colors.white),
                                  const SizedBox(height: 8),
                                  Container(height: 16, width: 180, color: Colors.white),
                                  const SizedBox(height: 8),
                                  Container(height: 14, width: 80, color: Colors.white),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Card(
                            elevation: 3,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                              child: Column(
                                children: [
                                  Stack(
                                    alignment: Alignment.bottomRight,
                                    children: [
                                      GestureDetector(
                                        onTap: state.isEditing
                                            ? () async {
                                                FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);
                                                if (result != null && result.files.single.path != null) {
                                                  context.read<AdminProfileBloc>().add(UploadProfilePicture(File(result.files.single.path!)));
                                                }
                                              }
                                            : null,
                                        child: CircleAvatar(
                                          radius: 60,
                                          backgroundImage: state.profilePicture.isNotEmpty
                                              ? NetworkImage(_resolveProfilePicture(state.profilePicture))
                                              : const AssetImage('assets/images/profile.webp') as ImageProvider,
                                        ),
                                      ),
                                      if (state.isEditing)
                                        Positioned(
                                          bottom: 0,
                                          right: 0,
                                          child: Material(
                                            color: Colors.transparent,
                                            child: IconButton(
                                              icon: const Icon(Icons.edit, color: Colors.white),
                                              onPressed: () async {
                                                FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);
                                                if (result != null && result.files.single.path != null) {
                                                  context.read<AdminProfileBloc>().add(UploadProfilePicture(File(result.files.single.path!)));
                                                }
                                              },
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  Text(state.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 4),
                                  Text(state.email, style: const TextStyle(fontSize: 16, color: Colors.black54)),
                                  const SizedBox(height: 2),
                                  Text('Role: ${state.role}', style: const TextStyle(fontSize: 14, color: Colors.black45)),
                                  const SizedBox(height: 16),
                                  if (state.isEditing)
                                    Column(
                                      children: [
                                        TextFormField(
                                          initialValue: state.name,
                                          decoration: const InputDecoration(labelText: 'Name', border: OutlineInputBorder()),
                                          onChanged: (val) => context.read<AdminProfileBloc>().add(ProfileFieldChanged('name', val)),
                                        ),
                                        const SizedBox(height: 16),
                                        TextFormField(
                                          initialValue: state.email,
                                          decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
                                          onChanged: (val) => context.read<AdminProfileBloc>().add(ProfileFieldChanged('email', val)),
                                        ),
                                        const SizedBox(height: 16),
                                        TextFormField(
                                          initialValue: state.contactNo,
                                          decoration: const InputDecoration(labelText: 'Contact No', border: OutlineInputBorder()),
                                          onChanged: (val) => context.read<AdminProfileBloc>().add(ProfileFieldChanged('contactNo', val)),
                                        ),
                                        const SizedBox(height: 24),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            ElevatedButton(
                                              onPressed: state.isLoading
                                                  ? null
                                                  : () => context.read<AdminProfileBloc>().add(SaveProfile(
                                                        name: state.name,
                                                        email: state.email,
                                                        contactNo: state.contactNo,
                                                      )),
                                              child: state.isLoading ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Save'),
                                            ),
                                            const SizedBox(width: 16),
                                            OutlinedButton(
                                              onPressed: state.isLoading
                                                  ? null
                                                  : () => context.read<AdminProfileBloc>().add(EditProfileToggled()),
                                              child: const Text('Cancel'),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                  else
                                    Column(
                                      children: [
                                        Text('Contact: ${state.contactNo}', style: const TextStyle(fontSize: 14)),
                                        const SizedBox(height: 24),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            ElevatedButton(
                                              onPressed: () => context.read<AdminProfileBloc>().add(EditProfileToggled()),
                                              child: const Text('Edit Profile'),
                                            ),
                                            const SizedBox(width: 16),
                                            OutlinedButton(
                                              onPressed: () => _showChangePasswordDialog(context, state),
                                              child: const Text('Change Password'),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 16),
                                        OutlinedButton(
                                          onPressed: () => _showDeactivateDialog(context),
                                          style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                                          child: const Text('Deactivate Account'),
                                        ),
                                      ],
                                    ),
                                  if (state.error.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 16.0),
                                      child: Text(state.error, style: const TextStyle(color: Colors.red)),
                                    ),
                                  if (state.success.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 16.0),
                                      child: Text(state.success, style: const TextStyle(color: Colors.green)),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
            );
          },
        ),
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext parentContext, AdminProfileState state) {
    showDialog(
      context: parentContext,
      builder: (context) {
        String current = '';
        String newPw = '';
        String confirm = '';
        bool showCurrent = false;
        bool showNew = false;
        bool showConfirm = false;
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Change Password'),
              content: SizedBox(
                width: 500,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      obscureText: !showCurrent,
                      decoration: InputDecoration(
                        labelText: 'Current Password',
                        suffixIcon: IconButton(
                          icon: Icon(showCurrent ? Icons.visibility : Icons.visibility_off),
                          onPressed: () => setState(() => showCurrent = !showCurrent),
                        ),
                      ),
                      onChanged: (val) => current = val,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      obscureText: !showNew,
                      decoration: InputDecoration(
                        labelText: 'New Password',
                        suffixIcon: IconButton(
                          icon: Icon(showNew ? Icons.visibility : Icons.visibility_off),
                          onPressed: () => setState(() => showNew = !showNew),
                        ),
                      ),
                      onChanged: (val) => newPw = val,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      obscureText: !showConfirm,
                      decoration: InputDecoration(
                        labelText: 'Confirm New Password',
                        suffixIcon: IconButton(
                          icon: Icon(showConfirm ? Icons.visibility : Icons.visibility_off),
                          onPressed: () => setState(() => showConfirm = !showConfirm),
                        ),
                      ),
                      onChanged: (val) => confirm = val,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    parentContext.read<AdminProfileBloc>().add(ChangePasswordRequested(current, newPw, confirm));
                    Navigator.pop(context);
                  },
                  child: const Text('Change'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showDeactivateDialog(BuildContext parentContext) {
    showDialog(
      context: parentContext,
      builder: (context) => AlertDialog(
        title: const Text('Deactivate Account'),
        content: const SizedBox(
          width: 500,
          child: Text('Are you sure you want to deactivate your account?'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              parentContext.read<AdminProfileBloc>().add(DeactivateAccountRequested());
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Deactivate'),
          ),
        ],
      ),
    );
  }
}
