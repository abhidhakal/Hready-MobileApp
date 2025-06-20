import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hready/features/auth/presentation/viewmodel/auth_event.dart';
import 'package:hready/features/auth/presentation/viewmodel/auth_state.dart';
import 'package:hready/features/auth/domain/use_cases/login_use_case.dart';
import 'package:hready/features/auth/domain/use_cases/register_admin_use_case.dart';
import 'package:hready/features/auth/domain/use_cases/register_employee_use_case.dart';

class AuthViewModel extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterAdminUseCase registerAdminUseCase;
  final RegisterEmployeeUseCase registerEmployeeUseCase;

  AuthViewModel({
    required this.loginUseCase,
    required this.registerAdminUseCase,
    required this.registerEmployeeUseCase,
  }) : super(AuthInitial()) {
    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final (role, user) = await loginUseCase(event.email, event.password);
        emit(AuthSuccess(role: role, user: user));
      } catch (e) {
        emit(AuthFailure('Invalid email or password'));
      }
    });

    on<RegisterAdmin>((event, emit) async {
      emit(AuthLoading());
      try {
        await registerAdminUseCase(event.admin);
        emit(const AuthSuccess(role: 'admin', user: null));
      } catch (e) {
        emit(AuthFailure('Admin registration failed'));
      }
    });

    on<RegisterEmployee>((event, emit) async {
      emit(AuthLoading());
      try {
        await registerEmployeeUseCase(event.employee);
        emit(const AuthSuccess(role: 'employee', user: null));
      } catch (e) {
        print("❌ Employee registration error: $e");
        emit(AuthFailure('Employee registration failed'));
      }
    });
  }
}
