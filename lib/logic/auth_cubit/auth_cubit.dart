import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/repositories/auth_repository.dart';

// States
abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {}

class AuthFailure extends AuthState {
  final String message;
  const AuthFailure(this.message);
  @override
  List<Object> get props => [message];
}

class AuthRegistered extends AuthState {}

// Cubit
class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  AuthCubit(this._authRepository) : super(AuthInitial());

  Future<void> login(String username, String password) async {
    try {
      emit(AuthLoading());
      await _authRepository.login(username, password);
      await checkAuthStatus(); // Update state based on persistence
    } catch (e) {
      // Clean up the error message
      final message = e.toString().replaceAll('Exception: ', '');
      emit(AuthFailure(message));
    }
  }

  Future<void> register(String username, String email, String password) async {
    try {
      emit(AuthLoading());
      await _authRepository.register(username, email, password);
      // FakeStoreAPI doesn't allow real login with new users.
      // We emit AuthRegistered so the UI can redirect to Login.
      emit(AuthRegistered());
    } catch (e) {
      final message = e.toString().replaceAll('Exception: ', '');
      emit(AuthFailure(message));
    }
  }

  Future<void> checkAuthStatus() async {
    try {
      final isLoggedIn = await _authRepository.isLoggedIn();
      if (isLoggedIn) {
        emit(AuthSuccess());
      } else {
        emit(AuthInitial());
      }
    } catch (_) {
      emit(AuthInitial());
    }
  }

  Future<void> logout() async {
    await _authRepository.logout();
    emit(AuthInitial());
  }
}
