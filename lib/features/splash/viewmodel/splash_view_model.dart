import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hready/features/splash/viewmodel/splash_event.dart';
import 'package:hready/features/splash/viewmodel/splash_state.dart';

class SplashViewModel extends Bloc<SplashEvent, SplashState> {
  SplashViewModel() : super(SplashInitial()) {
    on<StartSplash>((event, emit) async {
      await Future.delayed(const Duration(milliseconds: 2400));
      emit(SplashCompleted());
    });
  }
}
