import 'package:drever_warr/core/cash/preferences_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum Language { english, arabic, kurdish }  

class LanguageCubit extends Cubit<Language> {
  static const _langKey = 'app_language';

  LanguageCubit() : super(Language.arabic) {
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final savedLang = await CacheManager.getData(_langKey);

    if (savedLang == 'en') {
      emit(Language.english);
    } else if (savedLang == 'ku') {

      emit(Language.kurdish);
    } else {
      emit(Language.arabic);
    }
  }

 
  Future<void> setLanguage(Language lang) async {
    String langCode;
    if (lang == Language.english) {
      langCode = 'en';
    } else if (lang == Language.kurdish) {
      langCode = 'ku';
    } else {
      langCode = 'ar';
    }

    await CacheManager.saveData(_langKey, langCode);
    emit(lang);
  }
}
