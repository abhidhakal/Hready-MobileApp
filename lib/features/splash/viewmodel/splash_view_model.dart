import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hready/features/auth/domain/use_cases/get_cached_user_use_case.dart';
import 'package:hready/features/splash/viewmodel/splash_event.dart';
import 'package:hready/features/splash/viewmodel/splash_state.dart';

class SplashViewModel extends Bloc<SplashEvent, SplashState> {
  final GetCachedUserUseCase getCachedUserUseCase;

  SplashViewModel({required this.getCachedUserUseCase}) : super(SplashInitial()) {
    on<StartSplash>((event, emit) async {
      await Future.delayed(const Duration(milliseconds: 2400));
      final user = await getCachedUserUseCase();
      if (user != null) {
        emit(SplashLoggedIn(user));
      } else {
        emit(SplashNotLoggedIn());
      }
    });
  }
}

