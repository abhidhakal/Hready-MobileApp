import 'package:equatable/equatable.dart';

class AdminProfileState extends Equatable {
  final String name;
  final String email;
  final String contactNo;
  final String profilePicture;
  final String role;
  final bool isEditing;
  final bool isLoading;
  final bool isUploading;
  final bool showPasswordModal;
  final String error;
  final String success;

  // Password fields (for modal)
  final String currentPassword;
  final String newPassword;
  final String confirmPassword;
  final bool showCurrent;
  final bool showNew;
  final bool showConfirm;

  const AdminProfileState({
    this.name = '',
    this.email = '',
    this.contactNo = '',
    this.profilePicture = '',
    this.role = 'admin',
    this.isEditing = false,
    this.isLoading = false,
    this.isUploading = false,
    this.showPasswordModal = false,
    this.error = '',
    this.success = '',
    this.currentPassword = '',
    this.newPassword = '',
    this.confirmPassword = '',
    this.showCurrent = false,
    this.showNew = false,
    this.showConfirm = false,
  });

  AdminProfileState copyWith({
    String? name,
    String? email,
    String? contactNo,
    String? profilePicture,
    String? role,
    bool? isEditing,
    bool? isLoading,
    bool? isUploading,
    bool? showPasswordModal,
    String? error,
    String? success,
    String? currentPassword,
    String? newPassword,
    String? confirmPassword,
    bool? showCurrent,
    bool? showNew,
    bool? showConfirm,
  }) {
    return AdminProfileState(
      name: name ?? this.name,
      email: email ?? this.email,
      contactNo: contactNo ?? this.contactNo,
      profilePicture: profilePicture ?? this.profilePicture,
      role: role ?? this.role,
      isEditing: isEditing ?? this.isEditing,
      isLoading: isLoading ?? this.isLoading,
      isUploading: isUploading ?? this.isUploading,
      showPasswordModal: showPasswordModal ?? this.showPasswordModal,
      error: error ?? '',
      success: success ?? '',
      currentPassword: currentPassword ?? this.currentPassword,
      newPassword: newPassword ?? this.newPassword,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      showCurrent: showCurrent ?? this.showCurrent,
      showNew: showNew ?? this.showNew,
      showConfirm: showConfirm ?? this.showConfirm,
    );
  }

  @override
  List<Object?> get props => [
    name, email, contactNo, profilePicture, role, isEditing, isLoading, isUploading, showPasswordModal, error, success,
    currentPassword, newPassword, confirmPassword, showCurrent, showNew, showConfirm
  ];
} 