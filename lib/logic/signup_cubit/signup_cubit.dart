import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// State
class SignupState extends Equatable {
  final bool isPasswordVisible;

  const SignupState({this.isPasswordVisible = false});

  SignupState copyWith({bool? isPasswordVisible}) {
    return SignupState(
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
    );
  }

  @override
  List<Object> get props => [isPasswordVisible];
}

// Cubit
class SignupCubit extends Cubit<SignupState> {
  SignupCubit() : super(const SignupState());

  void togglePasswordVisibility() {
    emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
  }
}
