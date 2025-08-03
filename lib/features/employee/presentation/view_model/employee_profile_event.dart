import 'package:equatable/equatable.dart';
import 'dart:io';

abstract class EmployeeProfileEvent extends Equatable {
  const EmployeeProfileEvent();
  @override
  List<Object?> get props => [];
}

class LoadEmployeeProfile extends EmployeeProfileEvent {}
class EditProfileToggled extends EmployeeProfileEvent {}
class SaveProfile extends EmployeeProfileEvent {
  final String name;
  final String email;
  final String contactNo;
  const SaveProfile({required this.name, required this.email, required this.contactNo});
  @override
  List<Object?> get props => [name, email, contactNo];
}
class ProfileFieldChanged extends EmployeeProfileEvent {
  final String field;
  final String value;
  const ProfileFieldChanged(this.field, this.value);
  @override
  List<Object?> get props => [field, value];
}
class UploadProfilePicture extends EmployeeProfileEvent {
  final File file;
  const UploadProfilePicture(this.file);
  @override
  List<Object?> get props => [file];
}
class ChangePasswordRequested extends EmployeeProfileEvent {
  final String currentPassword;
  final String newPassword;
  final String confirmPassword;
  const ChangePasswordRequested(this.currentPassword, this.newPassword, this.confirmPassword);
  @override
  List<Object?> get props => [currentPassword, newPassword, confirmPassword];
}
class DeactivateAccountRequested extends EmployeeProfileEvent {} 