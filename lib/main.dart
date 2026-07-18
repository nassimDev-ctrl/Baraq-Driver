import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/di/app_providers.dart';
import 'package:drever_warr/core/service/api_service.dart';
import 'package:drever_warr/core/style/text_style.dart';
import 'package:drever_warr/core/translate/language_cubit.dart';
import 'package:drever_warr/core/utils/service_locator.dart';
import 'package:drever_warr/features/home/presentation/view/splash_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';

import 'core/service/notification_service.dart';
import 'core/utils/navigator_key.dart';
import 'firebase_options.dart';

Future<void> requestAppPermissions() async {
  final permissions = <Permission>[
    Permission.locationWhenInUse,
    Permission.notification,
  ];

  for (final permission in permissions) {
    final status = await permission.status;

    if (status.isDenied || status.isRestricted || status.isPermanentlyDenied) {
      final result = await permission.request();

      if (result.isPermanentlyDenied) {
        await openAppSettings();
      }
    }
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  debugPrint('=== 1. setupServiceLocator ===');
  setupServiceLocator();

  debugPrint('=== 2. Firebase.initializeApp ===');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  debugPrint('=== 3. requestAppPermissions ===');
  await requestAppPermissions();

  debugPrint('=== 4. NotificationService setup ===');
  NotificationService.instance.setApiService(getIt.get<ApiService>());
  FirebaseMessaging.onBackgroundMessage(
    NotificationService.firebaseBackgroundHandler,
  );

  debugPrint('=== 5. NotificationService.init ===');
  await NotificationService.instance.init();
  debugPrint('=== 6. runApp ===');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        ...coreProviders,
        ...authProviders,
      ],
      child: BlocBuilder<LanguageCubit, Language>(
        builder: (context, language) {
          final isEnglish = language == Language.english;
          final currentLocale = Locale(isEnglish ? 'en' : 'ar');
          // Keep existing app direction mapping.
          final currentDirection =
              isEnglish ? TextDirection.rtl : TextDirection.ltr;

          return ScreenUtilInit(
            designSize: const Size(375, 866),
            minTextAdapt: true,
            splitScreenMode: true,
            child: MaterialApp(
              navigatorKey: navigatorKey,
              debugShowCheckedModeBanner: false,
              title: 'Barq Driver',
              locale: currentLocale,
              builder: (context, widget) {
                return Directionality(
                  textDirection: currentDirection,
                  child: widget!,
                );
              },
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale('ar'),
                Locale('en'),
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
                  selectionColor: AppColors.main1.withValues(alpha: 0.5),
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
