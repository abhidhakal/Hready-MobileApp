import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hready/features/employee/presentation/viewmodel/employee_profile_bloc.dart';
import 'package:hready/features/employee/presentation/viewmodel/employee_profile_event.dart';
import 'package:hready/features/employee/presentation/viewmodel/employee_profile_state.dart';
import 'package:file_picker/file_picker.dart';
import 'package:hready/features/auth/presentation/view/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:hready/core/utils/common_snackbar.dart';
import 'package:hready/core/network/api_base.dart';

class EmployeeProfile extends StatelessWidget {
  const EmployeeProfile({super.key});

  String _resolveProfilePicture(String picture) {
    if (picture.isEmpty) return 'assets/images/profile.webp';
    if (picture.startsWith('/uploads')) {
      return '$apiBaseUrl$picture';
    }
    if (picture.startsWith('http')) return picture;
    return 'assets/images/profile.webp';
  }

  void _showChangePasswordDialog(BuildContext parentContext, EmployeeProfileState state) {
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
                    parentContext.read<EmployeeProfileBloc>().add(ChangePasswordRequested(current, newPw, confirm));
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

  void _showDeactivateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Deactivate Account'),
        content: const Text('Are you sure you want to deactivate your account? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<EmployeeProfileBloc>().add(DeactivateAccountRequested());
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Deactivate'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EmployeeProfileBloc()..add(LoadEmployeeProfile()),
      child: BlocListener<EmployeeProfileBloc, EmployeeProfileState>(
        listenWhen: (previous, current) =>
            previous.success != current.success || previous.error != current.error,
        listener: (context, state) {
          if (state.success.isNotEmpty) {
            showCommonSnackbar(context, state.success);
          } else if (state.error.isNotEmpty) {
            showCommonSnackbar(context, state.error);
          }
        },
        child: BlocBuilder<EmployeeProfileBloc, EmployeeProfileState>(
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Profile'),
                backgroundColor: const Color(0xFFF5F5F5),
                foregroundColor: Colors.black,
                centerTitle: false,
                elevation: 0,
              ),
              body: state.isLoading
                  ? Center(
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
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
                    )
                  : SafeArea(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text('Employee Profile', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                            ),
                            const SizedBox(height: 18),
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
                                                    context.read<EmployeeProfileBloc>().add(UploadProfilePicture(File(result.files.single.path!)));
                                                  }
                                                }
                                              : null,
                                          child: CircleAvatar(
                                            radius: 60,
                                            backgroundColor: Colors.grey[200],
                                            child: ClipOval(
                                              child: (state.profilePicture.isNotEmpty && _resolveProfilePicture(state.profilePicture).isNotEmpty)
                                                  ? Image.network(
                                                      _resolveProfilePicture(state.profilePicture),
                                                      width: 120,
                                                      height: 120,
                                                      fit: BoxFit.cover,
                                                      errorBuilder: (context, error, stackTrace) => Image.asset('assets/images/profile.webp', width: 120, height: 120, fit: BoxFit.cover),
                                                    )
                                                  : Image.asset('assets/images/profile.webp', width: 120, height: 120, fit: BoxFit.cover),
                                            ),
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
                                                    context.read<EmployeeProfileBloc>().add(UploadProfilePicture(File(result.files.single.path!)));
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
                                            onChanged: (val) => context.read<EmployeeProfileBloc>().add(ProfileFieldChanged('name', val)),
                                          ),
                                          const SizedBox(height: 16),
                                          TextFormField(
                                            initialValue: state.email,
                                            decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
                                            onChanged: (val) => context.read<EmployeeProfileBloc>().add(ProfileFieldChanged('email', val)),
                                          ),
                                          const SizedBox(height: 16),
                                          TextFormField(
                                            initialValue: state.contactNo,
                                            decoration: const InputDecoration(labelText: 'Contact No', border: OutlineInputBorder()),
                                            onChanged: (val) => context.read<EmployeeProfileBloc>().add(ProfileFieldChanged('contactNo', val)),
                                          ),
                                          const SizedBox(height: 24),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              ElevatedButton(
                                                onPressed: state.isLoading
                                                    ? null
                                                    : () => context.read<EmployeeProfileBloc>().add(SaveProfile(
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
                                                    : () => context.read<EmployeeProfileBloc>().add(EditProfileToggled()),
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
                                                onPressed: () => context.read<EmployeeProfileBloc>().add(EditProfileToggled()),
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
                                    const SizedBox(height: 24),
                                    OutlinedButton(
                                      onPressed: () async {
                                        final prefs = await SharedPreferences.getInstance();
                                        await prefs.remove('token');
                                        await prefs.remove('userId');
                                        await prefs.remove('role');
                                        await prefs.remove('userName');
                                        // Optionally: await prefs.clear();
                                        Navigator.of(context).pushAndRemoveUntil(
                                          MaterialPageRoute(builder: (_) => const LoginPage()),
                                          (route) => false,
                                        );
                                      },
                                      style: OutlinedButton.styleFrom(foregroundColor: Colors.black),
                                      child: const Text('Logout'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
            );
          },
        ),
      ),
    );
  }
}
