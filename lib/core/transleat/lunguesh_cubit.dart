import 'package:drever_warr/core/cash/preferences_servis.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum Language { english, arabic, kurdish }  

class LanguageCubit extends Cubit<Language> {
  static const _langKey = 'app_language';

  LanguageCubit() : super(Language.english) {
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final savedLang = await CacheManager.getData(_langKey);

    if (savedLang == 'ar') {
      emit(Language.arabic);
    } else if (savedLang == 'ku') {
     
      emit(Language.kurdish);
    } else {
      emit(Language.english);
    }
  }

 
  Future<void> setLanguage(Language lang) async {
    String langCode;
    if (lang == Language.arabic)
      langCode = 'ar';
    else if (lang == Language.kurdish)
      langCode = 'ku';
    else
      langCode = 'en';

    await CacheManager.saveData(_langKey, langCode);
    emit(lang);
  }
}
