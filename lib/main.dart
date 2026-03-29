// import 'package:drever_warr/core/constant/app_colors.dart';
// import 'package:drever_warr/core/style/text_style.dart';
// import 'package:drever_warr/core/transleat/lunguesh_cubit.dart';
// import 'package:drever_warr/core/utiles/serves_lecture.dart';
// import 'package:drever_warr/features/preasntaion/widhets/regster.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
//  import 'package:flutter_screenutil/flutter_screenutil.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   setupServiceLocator();
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         // أبقينا فقط كيوبت اللغة
//         BlocProvider<LanguageCubit>(create: (_) => LanguageCubit()),
//         // BlocProvider(
//         //   create: (context) => RegisterCubit(
//         //     ImplementRepoRegister(
//         //       apiService: getIt.get<ApiService>(),
//         //     ), // إنشاء يدوي بدلاً من getIt
//         //   ),
//         // ),
//         // BlocProvider(
//         //   create: (context) => VerificationCubit(
//         //     VerificationRepoImpl(
//         //       apiService: getIt.get<ApiService>(),
//         //     ), // إنشاء يدوي بدلاً من getIt
//         //   ),
//         // ),
//         // BlocProvider(
//         //   create: (context) => LoginCubit(
//         //     ImplementRepoLogin(
//         //       apiService: getIt.get<ApiService>(),
//         //     ), // إنشاء يدوي بدلاً من getIt
//         //   ),
//         // ),
//         // BlocProvider(
//         //   create: (context) => ConfirmPasswordCubit(
//         //     ConfirmPasswordRepoImpl(
//         //       getIt.get<ApiService>(),
//         //     ), // إنشاء يدوي بدلاً من getIt
//         //   ),
//         // ),
//         // BlocProvider(
//         //   create: (context) => GovernoratesCubit(
//         //     RepoGovernoratesImpl(
//         //       getIt.get<ApiService>(),
//         //     ), // إنشاء يدوي بدلاً من getIt
//         //   ),
//         // ),
//         // BlocProvider(
//         //   create: (context) => CarCategoriesCubit(
//         //     RepoCarCategoriesImpl(
//         //       getIt.get<ApiService>(),
//         //     ), // إنشاء يدوي بدلاً من getIt
//         //   ),
//         // ),
//         // BlocProvider(
//         //   create: (context) => DiscountCubit(
//         //     RepoDiscountImpl(
//         //       getIt.get<ApiService>(),
//         //     ), // إنشاء يدوي بدلاً من getIt
//         //   ),
//         // ),
//         // BlocProvider(
//         //   create: (context) => CreateTripCubit(
//         //     RepoCreateTripImpl(
//         //       getIt.get<ApiService>(),
//         //     ), // إنشاء يدوي بدلاً من getIt
//         //   ),
//         // ),
//         // BlocProvider(
//         //   create: (context) => ConfirmDriverCubit(
//         //     RepoConfirmDriverImpl(
//         //       getIt.get<ApiService>(),
//         //     ), // إنشاء يدوي بدلاً من getIt
//         //   ),
//         // ),
//         // BlocProvider(
//         //   create: (context) => UpdateMobileCubit(
//         //     RepoUpdateMobileImpl(
//         //       getIt.get<ApiService>(),
//         //     ), // إنشاء يدوي بدلاً من getIt
//         //   ),
//         // ),
//         // BlocProvider(
//         //   create: (context) => ChangePasswordCubit(
//         //     ChangePasswordRepoImpl(
//         //       getIt.get<ApiService>(),
//         //     ), // إنشاء يدوي بدلاً من getIt
//         //   ),
//         // ),
//         // BlocProvider(
//         //   create: (context) => UpdateProfileCubit(
//         //     UpdateProfileRepoImpl(
//         //       getIt.get<ApiService>(),
//         //     ), // إنشاء يدوي بدلاً من getIt
//         //   ),
//         // ),
//       ],
//       child: BlocBuilder<LanguageCubit, Language>(
//         builder: (context, language) {
//           final isArabic = language == Language.arabic;

//           return ScreenUtilInit(
//             designSize: const Size(375, 866),
//             minTextAdapt: true,
//             splitScreenMode: true,
//             child: MaterialApp(
//               debugShowCheckedModeBanner: false,
//               title: 'Flutter Demo',

//               // إعدادات اللغة والترجمة
//               locale: isArabic ? const Locale('ar') : const Locale('en'),

//               builder: (context, widget) {
//                 return Directionality(
//                   textDirection: isArabic
//                       ? TextDirection.ltr
//                       : TextDirection.rtl,
//                   child: widget!,
//                 );
//               },
//               // 2. هذه الإعدادات ضرورية جداً لعمل الاتجاهات (RTL / LTR)
//               localizationsDelegates: const [
//                 GlobalMaterialLocalizations.delegate,
//                 GlobalWidgetsLocalizations.delegate,
//                 GlobalCupertinoLocalizations.delegate,
//               ],

//               // 3. تحديد اللغات المدعومة
//               supportedLocales: const [
//                 Locale('ar'), // العربية (Right-to-Left)
//                 Locale('en'), // الإنجليزية (Left-to-Right)
//               ],

//               // 4. لإجبار التطبيق على اتباع لغة الـ locale المحددة فوق
//               localeResolutionCallback: (deviceLocale, supportedLocales) {
//                 return isArabic ? const Locale('ar') : const Locale('en');
//               },
//               // إعدادات الثيم (الخط)
//               theme: ThemeData(
//                 fontFamily: AppTextStyles.fontFamily,
//                 textTheme: const TextTheme(
//                   displayLarge: AppTextStyles.displayLarge,
//                   titleLarge: AppTextStyles.titleLarge,
//                   titleMedium: AppTextStyles.titleMedium,
//                   bodyLarge: AppTextStyles.bodyLarge,
//                   bodyMedium: AppTextStyles.bodyMedium,
//                   titleSmall: AppTextStyles.titleSmall,
//                   bodySmall: AppTextStyles.bodySmall,
//                   labelSmall: AppTextStyles.caption,
//                 ),
//                 textSelectionTheme: TextSelectionThemeData(
//                   cursorColor: AppColors.main1,
//                   selectionColor: AppColors.main1.withOpacity(0.5),
//                   selectionHandleColor: AppColors.main1,
//                 ),
//                 // إضافة إعدادات الـ AppBar العامة لضمان ثبات اللون عند السكرول في كل التطبيق
//                 appBarTheme: const AppBarTheme(
//                   surfaceTintColor: Colors.transparent,
//                   scrolledUnderElevation: 0,
//                 ),
//               ),

//               // الشاشة الرئيسية البدائية (يمكنك تغييرها لاحقاً)
//               home: Regsterview(),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/style/text_style.dart';
import 'package:drever_warr/core/transleat/lunguesh_cubit.dart';
import 'package:drever_warr/core/utiles/serves_lecture.dart';
import 'package:drever_warr/features/home/preasntaion/view/splash_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupServiceLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider<LanguageCubit>(create: (_) => LanguageCubit())],
      child: BlocBuilder<LanguageCubit, Language>(
        builder: (context, language) {
          // 1. تحديد الـ Locale والاتجاه بناءً على الحالة
          Locale currentLocale;
          TextDirection currentDirection;

          switch (language) {
            case Language.arabic:
              currentLocale = const Locale('ar');
              currentDirection = TextDirection.ltr; // من اليمين لليسار
              break;
            case Language.kurdish:
              currentLocale = const Locale('ku');
              currentDirection =
                  TextDirection.rtl; // الكورمانجي يكتب لاتيني LTR
              break;
            case Language.english:
            default:
              currentLocale = const Locale('en');
              currentDirection = TextDirection.rtl; // من اليسار لليمين
              break;
          }

          return ScreenUtilInit(
            designSize: const Size(375, 866),
            minTextAdapt: true,
            splitScreenMode: true,
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Warr App',
              locale: currentLocale,

              builder: (context, widget) {
                return Directionality(
                  textDirection: currentDirection,
                  child: widget!,
                );
              },

              // 2. تم إضافة الـ Fallback هنا لحل مشكلة الـ TextFormField
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
                KurdishMaterialLocalizationsDelegate(), // المفوّض المخصص
                KurdishCupertinoLocalizationsDelegate(), // المفوّض المخصص
              ],

              supportedLocales: const [
                Locale('ar'),
                Locale('en'),
                Locale('ku'),
              ],

              localeResolutionCallback: (deviceLocale, supportedLocales) {
                return currentLocale;
              },

              theme: ThemeData(
                fontFamily: AppTextStyles.fontFamily,
                textTheme: const TextTheme(
                  displayLarge: AppTextStyles.displayLarge,
                  titleLarge: AppTextStyles.titleLarge,
                  titleMedium: AppTextStyles.titleMedium,
                  bodyLarge: AppTextStyles.bodyLarge,
                  bodyMedium: AppTextStyles.bodyMedium,
                  titleSmall: AppTextStyles.titleSmall,
                  bodySmall: AppTextStyles.bodySmall,
                  labelSmall: AppTextStyles.caption,
                ),
                textSelectionTheme: TextSelectionThemeData(
                  cursorColor: AppColors.main1,
                  selectionColor: AppColors.main1.withOpacity(0.5),
                  selectionHandleColor: AppColors.main1,
                ),
                appBarTheme: const AppBarTheme(
                  surfaceTintColor: Colors.transparent,
                  scrolledUnderElevation: 0,
                ),
              ),
              home: const SplashView(),
            ),
          );
        },
      ),
    );
  }
}

// --- كلاسات حل مشكلة اللغة الكردية في نصوص النظام ---

class KurdishMaterialLocalizationsDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  const KurdishMaterialLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'ku';

  @override
  Future<MaterialLocalizations> load(Locale locale) async {
    // نستخدم ترجمة الإنجليزية لنصوص النظام (مثل Copy/Paste) لتجنب الانهيار
    return await GlobalMaterialLocalizations.delegate.load(const Locale('en'));
  }

  @override
  bool shouldReload(KurdishMaterialLocalizationsDelegate old) => false;
}

class KurdishCupertinoLocalizationsDelegate
    extends LocalizationsDelegate<CupertinoLocalizations> {
  const KurdishCupertinoLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'ku';

  @override
  Future<CupertinoLocalizations> load(Locale locale) async {
    return await GlobalCupertinoLocalizations.delegate.load(const Locale('en'));
  }

  @override
  bool shouldReload(KurdishCupertinoLocalizationsDelegate old) => false;
}
