import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repo/update_language_repo/repo.dart';
import 'cubit.dart';

class UpdateLanguageCubit extends Cubit<UpdateLanguageState> {
  final LanguageRepository languageRepository;

  UpdateLanguageCubit(this.languageRepository) : super(UpdateLanguageInitial());

  Future<void> changeLanguage(String languageCode) async {
    emit(UpdateLanguageLoading());

    final result = await languageRepository.changeLanguage(languageCode);

    result.fold(
          (failure) => emit(UpdateLanguageFailure(failure.errMassage)),
          (message) => emit(UpdateLanguageSuccess(message)),
    );
  }
}