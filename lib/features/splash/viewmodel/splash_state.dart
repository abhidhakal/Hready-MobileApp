import 'package:equatable/equatable.dart';
import 'package:hready/features/auth/domain/entities/user_entity.dart';

abstract class SplashState extends Equatable {
  const SplashState();

  @override
  List<Object?> get props => [];
}

class SplashInitial extends SplashState {}

class SplashCompleted extends SplashState {}

class SplashLoggedIn extends SplashState {
  final UserEntity user;
  SplashLoggedIn(this.user);
}

class SplashNotLoggedIn extends SplashState {}

