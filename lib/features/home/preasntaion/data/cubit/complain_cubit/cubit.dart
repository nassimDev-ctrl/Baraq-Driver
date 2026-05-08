import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';

import '../repo/complain_repo/repo.dart';
import 'cubit_state.dart';

class AddComplainCubit extends Cubit<AddComplainState> {
  final AddComplainRepository addComplainRepository;

  AddComplainCubit(this.addComplainRepository) : super(AddComplainInitial());

  Future<void> sendComplain({
    required String description,
    File? image,
  }) async {
    emit(AddComplainLoading());

    final result = await addComplainRepository.sendComplain(
      description: description,
      image: image,
    );

    result.fold(
          (failure) => emit(AddComplainFailure(failure.errMassage)),
          (successMessage) => emit(AddComplainSuccess(successMessage)),
    );
  }
}