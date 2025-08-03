import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hready/features/auth/domain/use_cases/get_cached_user_use_case.dart';
import 'package:hready/features/auth/domain/use_cases/login_use_case.dart';
import 'package:hready/features/auth/domain/use_cases/register_use_case.dart';
import 'package:hready/core/error/error_handler.dart';
import 'package:hready/core/error/app_exceptions.dart';
import 'auth_event.dart';
import 'auth_state.dart';
class AuthViewModel extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final GetCachedUserUseCase getCachedUserUseCase;

  AuthViewModel({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.getCachedUserUseCase,
  }) : super(AuthInitial()) {
    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await loginUseCase(event.email, event.password);
        emit(AuthSuccess(user));
      } catch (e) {
        final exception = ErrorHandler.handle(e);
        ErrorHandler.logError(exception);
        emit(AuthFailure(exception.message));
      }
    });

    on<RegisterRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await registerUseCase(event.payload);
        emit(AuthSuccess(user));
      } catch (e) {
        final exception = ErrorHandler.handle(e);
        ErrorHandler.logError(exception);
        emit(AuthFailure(exception.message));
      }
    });

    on<GetCachedUserRequested>((event, emit) async {
      final user = await getCachedUserUseCase();
      if (user != null) {
        emit(AuthSuccess(user));
      } else {
        emit(AuthInitial());
      }
    });
  }
}
