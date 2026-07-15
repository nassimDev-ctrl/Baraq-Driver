import 'package:flutter_bloc/flutter_bloc.dart';

import '../repo/logout_repo/repo.dart';
import 'cubit_state.dart';

class LogoutCubit extends Cubit<LogoutState> {
  final LogoutRepository logoutRepository;

  LogoutCubit(this.logoutRepository) : super(LogoutInitial());

  Future<void> logout() async {
    emit(LogoutLoading());

    final result = await logoutRepository.logout();

    result.fold(
          (failure) => emit(LogoutFailure(failure.errMessage)),
          (message) => emit(LogoutSuccess(message)),
    );
  }
}