import 'package:drever_warr/core/cash/preferences_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum Language { english, arabic }

class LanguageCubit extends Cubit<Language> {
  static const _langKey = 'app_language';

  LanguageCubit() : super(Language.arabic) {
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final savedLang = await CacheManager.getData(_langKey);

    if (savedLang == 'en') {
      emit(Language.english);
    } else {
      // Arabic default; migrate any legacy 'ku' to Arabic.
      if (savedLang == 'ku') {
        await CacheManager.saveData(_langKey, 'ar');
      }
      emit(Language.arabic);
    }
  }

  Future<void> setLanguage(Language lang) async {
    final langCode = lang == Language.english ? 'en' : 'ar';
    await CacheManager.saveData(_langKey, langCode);
    emit(lang);
  }
}
