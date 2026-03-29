import 'package:drever_warr/core/cash/preferences_servis.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum Language { english, arabic, kurdish } // إضافة الكردية هنا

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
      // إضافة التحقق من الكردية
      emit(Language.kurdish);
    } else {
      emit(Language.english);
    }
  }

  // دالة لتغيير اللغة مباشرة
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
