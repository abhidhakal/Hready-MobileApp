import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'employee_profile_event.dart';
import 'employee_profile_state.dart';
import 'package:hready/app/service_locator/service_locator.dart';

class EmployeeProfileBloc extends Bloc<EmployeeProfileEvent, EmployeeProfileState> {
  final Dio dio = getIt<Dio>();

  EmployeeProfileBloc() : super(const EmployeeProfileState()) {
    on<LoadEmployeeProfile>(_onLoadProfile);
    on<EditProfileToggled>(_onEditToggled);
    on<ProfileFieldChanged>(_onFieldChanged);
    on<SaveProfile>(_onSaveProfile);
    on<UploadProfilePicture>(_onUploadPicture);
    on<ChangePasswordRequested>(_onChangePassword);
    on<DeactivateAccountRequested>(_onDeactivate);
  }

  Future<void> _onLoadProfile(LoadEmployeeProfile event, Emitter<EmployeeProfileState> emit) async {
    emit(state.copyWith(isLoading: true, error: '', success: ''));
    try {
      final res = await dio.get('/employees/me');
      emit(state.copyWith(
        isLoading: false,
        name: res.data['name'] ?? '',
        email: res.data['email'] ?? '',
        contactNo: res.data['contactNo'] ?? '',
        profilePicture: res.data['profilePicture'] ?? '',
        role: res.data['role'] ?? 'employee',
        position: res.data['position'] ?? '',
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: 'Failed to load profile'));
    }
  }

  void _onEditToggled(EditProfileToggled event, Emitter<EmployeeProfileState> emit) {
    emit(state.copyWith(isEditing: !state.isEditing, error: '', success: ''));
  }

  void _onFieldChanged(ProfileFieldChanged event, Emitter<EmployeeProfileState> emit) {
    switch (event.field) {
      case 'name':
        emit(state.copyWith(name: event.value));
        break;
      case 'email':
        emit(state.copyWith(email: event.value));
        break;
      case 'contactNo':
        emit(state.copyWith(contactNo: event.value));
        break;
    }
  }

  Future<void> _onSaveProfile(SaveProfile event, Emitter<EmployeeProfileState> emit) async {
    emit(state.copyWith(isLoading: true, error: '', success: ''));
    try {
      await dio.put('/employees/me', data: {
        'name': event.name,
        'email': event.email,
        'contactNo': event.contactNo,
      });
      emit(state.copyWith(isLoading: false, isEditing: false, success: 'Profile updated successfully.'));
      add(LoadEmployeeProfile());
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: 'Failed to update profile.'));
    }
  }

  Future<void> _onUploadPicture(UploadProfilePicture event, Emitter<EmployeeProfileState> emit) async {
    emit(state.copyWith(isUploading: true, error: '', success: ''));
    try {
      final ext = event.file.path.split('.').last.toLowerCase();
      String mimeType = 'image/jpeg';
      if (ext == 'png') mimeType = 'image/png';
      final formData = FormData.fromMap({
        'profilePicture': await MultipartFile.fromFile(
          event.file.path,
          filename: event.file.path.split('/').last,
          contentType: MediaType.parse(mimeType),
        ),
      });
      await dio.put('/employees/upload-profile-picture', data: formData);
      emit(state.copyWith(isUploading: false, success: 'Profile picture updated.'));
      add(LoadEmployeeProfile());
    } catch (e) {
      emit(state.copyWith(isUploading: false, error: 'Failed to upload picture.'));
    }
  }

  Future<void> _onChangePassword(ChangePasswordRequested event, Emitter<EmployeeProfileState> emit) async {
    if (event.newPassword != event.confirmPassword) {
      emit(state.copyWith(error: 'New passwords do not match.'));
      return;
    }
    emit(state.copyWith(isLoading: true, error: '', success: ''));
    try {
      await dio.put('/employees/change-password', data: {
        'currentPassword': event.currentPassword,
        'newPassword': event.newPassword,
      });
      emit(state.copyWith(isLoading: false, showPasswordModal: false, success: 'Password changed successfully.'));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: 'Failed to change password.'));
    }
  }

  Future<void> _onDeactivate(DeactivateAccountRequested event, Emitter<EmployeeProfileState> emit) async {
    emit(state.copyWith(isLoading: true, error: '', success: ''));
    try {
      await dio.delete('/employees/me');
      emit(state.copyWith(isLoading: false, success: 'Account deactivated.'));
      // You may want to add navigation or logout logic here
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: 'Failed to deactivate account.'));
    }
  }
} 