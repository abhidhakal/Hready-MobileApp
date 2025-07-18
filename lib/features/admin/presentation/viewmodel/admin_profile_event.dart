import 'package:equatable/equatable.dart';
import 'dart:io';

abstract class AdminProfileEvent extends Equatable {
  const AdminProfileEvent();
  @override
  List<Object?> get props => [];
}

class LoadAdminProfile extends AdminProfileEvent {}
class EditProfileToggled extends AdminProfileEvent {}
class SaveProfile extends AdminProfileEvent {
  final String name;
  final String email;
  final String contactNo;
  const SaveProfile({required this.name, required this.email, required this.contactNo});
  @override
  List<Object?> get props => [name, email, contactNo];
}
class ProfileFieldChanged extends AdminProfileEvent {
  final String field;
  final String value;
  const ProfileFieldChanged(this.field, this.value);
  @override
  List<Object?> get props => [field, value];
}
class UploadProfilePicture extends AdminProfileEvent {
  final File file;
  const UploadProfilePicture(this.file);
  @override
  List<Object?> get props => [file];
}
class ChangePasswordRequested extends AdminProfileEvent {
  final String currentPassword;
  final String newPassword;
  final String confirmPassword;
  const ChangePasswordRequested(this.currentPassword, this.newPassword, this.confirmPassword);
  @override
  List<Object?> get props => [currentPassword, newPassword, confirmPassword];
}
class DeactivateAccountRequested extends AdminProfileEvent {} 