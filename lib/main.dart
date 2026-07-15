import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/service/api_servise.dart';
import 'package:drever_warr/core/style/text_style.dart';
import 'package:drever_warr/core/transleat/lunguesh_cubit.dart';
import 'package:drever_warr/core/utiles/serves_lecture.dart';
import 'package:drever_warr/features/home/preasntaion/data/cubit/complain_cubit/cubit.dart';
import 'package:drever_warr/features/home/preasntaion/data/cubit/cubit_finsh_trips/cubit.dart';
import 'package:drever_warr/features/home/preasntaion/data/cubit/cubit_notification/cubit.dart';
import 'package:drever_warr/features/home/preasntaion/data/cubit/cubit_wallat/cubit.dart';
import 'package:drever_warr/features/home/preasntaion/data/cubit/logout_cubit/cubit.dart';
import 'package:drever_warr/features/home/preasntaion/data/cubit/repo/complain_repo/repo_impl.dart';
import 'package:drever_warr/features/home/preasntaion/data/cubit/repo/finsh_trips_repo/repo_implmntion.dart';
import 'package:drever_warr/features/home/preasntaion/data/cubit/repo/logout_repo/repo_impl.dart';
import 'package:drever_warr/features/home/preasntaion/data/cubit/repo/repo_notification/repo_implmantion.dart';
import 'package:drever_warr/features/home/preasntaion/data/cubit/repo/repo_wallat/repo_implmantion.dart';
import 'package:drever_warr/features/home/preasntaion/view/splash_view.dart';
import 'package:drever_warr/features/my_oreder/preasntaion/data/cubit/ScheduledTrips_cubit/cubit.dart';
import 'package:drever_warr/features/my_oreder/preasntaion/data/cubit/accept_order_cubit/cubit.dart';
import 'package:drever_warr/features/my_oreder/preasntaion/data/cubit/cubet_end_tripe/cubit.dart';
import 'package:drever_warr/features/my_oreder/preasntaion/data/cubit/cubit_current_trip/cubit.dart';
import 'package:drever_warr/features/my_oreder/preasntaion/data/cubit/cubit_order/cubit.dart';
import 'package:drever_warr/features/my_oreder/preasntaion/data/cubit/cubit_start_order/cubit.dart';
import 'package:drever_warr/features/my_oreder/preasntaion/data/cubit/repo/accept_order_repo/repo_implmantion.dart';
import 'package:drever_warr/features/my_oreder/preasntaion/data/cubit/repo/repo_end_tripe/repo_implmantion.dart';
import 'package:drever_warr/features/my_oreder/preasntaion/data/cubit/repo/repo_order/ScheduledTrips_repo/repo_implmantion.dart';
import 'package:drever_warr/features/my_oreder/preasntaion/data/cubit/repo/repo_order/repo_implmantion.dart';
import 'package:drever_warr/features/my_oreder/preasntaion/data/cubit/repo/repo_start_tripe/repo_implmantion.dart';
import 'package:drever_warr/features/my_oreder/preasntaion/data/cubit/trip_details_cubit/cubit.dart';
import 'package:drever_warr/features/my_oreder/preasntaion/data/repo/current_trip_repo/repo_impl.dart';
import 'package:drever_warr/features/my_oreder/preasntaion/data/repo/trip_details_repo/repo_implementation.dart';
import 'package:drever_warr/features/my_tripe/data/cubit/cubit_messages/cubit.dart';
import 'package:drever_warr/features/my_tripe/data/cubit/cubit_ratting/cubit.dart';
import 'package:drever_warr/features/my_tripe/data/cubit/cubit_trip_note/cubit.dart';
import 'package:drever_warr/features/my_tripe/data/repo/details_single_trip_repo/repo_impl.dart';
import 'package:drever_warr/features/my_tripe/data/repo/messages_repo/repo_impl.dart';
import 'package:drever_warr/features/my_tripe/data/repo/repo_rating/repo_implmantion.dart';
import 'package:drever_warr/features/my_tripe/data/repo/trip_note_repo/repo_impl.dart';
import 'package:drever_warr/features/preasntaion/data/repo/cubit/cubit_car_all_filld/cubit.dart';
import 'package:drever_warr/features/preasntaion/data/repo/cubit/cubit_car_image/cubit.dart';
import 'package:drever_warr/features/preasntaion/data/repo/cubit/cubit_category/cubit.dart';
import 'package:drever_warr/features/preasntaion/data/repo/cubit/cubit_forget_passwrde/cubit.dart';
import 'package:drever_warr/features/preasntaion/data/repo/cubit/cubit_governorates/cubit.dart';
import 'package:drever_warr/features/preasntaion/data/repo/cubit/cubit_information_car/cubit.dart';
import 'package:drever_warr/features/preasntaion/data/repo/cubit/cubit_login/cubit.dart';
import 'package:drever_warr/features/preasntaion/data/repo/cubit/cubit_personal_image/cubit.dart';
import 'package:drever_warr/features/preasntaion/data/repo/cubit/cubit_regster.dart/cubit_rejester.dart';
import 'package:drever_warr/features/preasntaion/data/repo/cubit/cubit_verificationRepo/cubit.dart';
import 'package:drever_warr/features/preasntaion/data/repo/repo/repo_car_all_filld/repo_implmantion.dart';
import 'package:drever_warr/features/preasntaion/data/repo/repo/repo_car_image/repo_implmantion.dart';
import 'package:drever_warr/features/preasntaion/data/repo/repo/repo_category/repo_implmantion.dart';
import 'package:drever_warr/features/preasntaion/data/repo/repo/repo_forget_passwrd/repo_implmantion.dart';
import 'package:drever_warr/features/preasntaion/data/repo/repo/repo_information_car/repo_implmantion.dart';
import 'package:drever_warr/features/preasntaion/data/repo/repo/repo_login/repo_implmantion.dart';
import 'package:drever_warr/features/preasntaion/data/repo/repo/repo_personal_image/repo_implmantion.dart';
import 'package:drever_warr/features/preasntaion/data/repo/repo/repo_verificationRepo/repo_implmantion.dart';
import 'package:drever_warr/features/preasntaion/data/repo/repo_implmantion.dart';
import 'package:drever_warr/features/setting/data/cubit/cubit_edit_passwrd/cubit.dart';
import 'package:drever_warr/features/setting/data/cubit/cubit_profail/cubit.dart';
import 'package:drever_warr/features/setting/data/cubit/cubit_updet_phone/cubit.dart';
import 'package:drever_warr/features/setting/data/cubit/updet_profail/cubit.dart';
import 'package:drever_warr/features/setting/data/repo/repo_edit_passowrd/repo_implmantion.dart';
import 'package:drever_warr/features/setting/data/repo/repo_profail/repo_implmantion.dart';
import 'package:drever_warr/features/setting/data/repo/repo_updet_phone.dart/repo_implmantion.dart';
import 'package:drever_warr/features/setting/data/repo/repo_updet_profail/repo_implmantion.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/service/notification_service.dart';
import 'features/home/preasntaion/data/cubit/cubit_update_location/cubit.dart';
import 'features/home/preasntaion/data/cubit/driver_available_cubit/cubit.dart';
import 'features/home/preasntaion/data/cubit/repo/driver_available_repo/repo.dart';
import 'features/home/preasntaion/data/cubit/repo/update_location/repo_implementation.dart';
import 'features/my_oreder/preasntaion/data/cubit/repo/scheduled_accept_order_repo/repo_implmantion.dart';
import 'features/my_oreder/preasntaion/data/cubit/scheduled_accept_order_cubit/cubit.dart';
import 'features/my_tripe/data/cubit/cubit_details_single_trip/cubit.dart';
import 'features/setting/data/cubit/cubit_update_language/cubit_state.dart';
import 'features/setting/data/repo/update_language_repo/repo.dart';
import 'firebase_options.dart';
import 'package:permission_handler/permission_handler.dart';
import 'core/utiles/navigator_key.dart';

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
        BlocProvider(
          create: (context) => getIt<GovernoratesCubit>(),
        ),
        BlocProvider(
          create: (context) => VerificationCubit(
            VerificationRepoImpl(
              apiService: getIt.get<ApiService>(),
            ),
          ),
        ),
        BlocProvider(
          create: (context) => RegisterCubit(
            ImplementRepoRegister(
              apiService: getIt.get<ApiService>(),
            ),
          ),
        ),
        BlocProvider(
          create: (context) => LoginCubit(
            ImplementRepoLogin(
              apiService: getIt.get<ApiService>(),
            ),
          ),
        ),
        BlocProvider(
          create: (context) => ConfirmPasswordCubit(
            ConfirmPasswordRepoImpl(
              getIt.get<ApiService>(),
            ),
          ),
        ),
        BlocProvider(
          create: (context) => UploadImageCubit(
            ImplementRepoUploadImage(
              apiService: getIt.get<ApiService>(),
            ),
          ),
        ),
        BlocProvider(
          create: (context) => UploadIdCubit(
            ImplementRepoUploadId(
              apiService: getIt.get<ApiService>(),
            ),
          ),
        ),
        BlocProvider(
          create: (context) => CarInfoCubit(
            ImplementRepoCarInfo(
              apiService: getIt.get<ApiService>(),
            ),
          ),
        ),
        BlocProvider(
          create: (context) => LogoutCubit(
            LogoutRepositoryImpl(
              getIt.get<ApiService>(),
            ),
          ),
        ),
        BlocProvider(
          create: (context) => CarAllFilldCubit(
            CarAllFilldRepoImpl(
              apiService: getIt.get<ApiService>(),
            ),
          ),
        ),
        BlocProvider(
          create: (context) => ChatCubit(
            ChatRepositoryImpl(
              getIt.get<ApiService>(),
            ),
          ),
        ),
        BlocProvider(
          create: (context) => CarCategoryCubit(
            RepoCarCategoryImpl(
              getIt.get<ApiService>(),
            ),
          ),
        ),
        BlocProvider(
          create: (context) => SearchingTripsCubit(
            RepoSearchingTripsImpl(
              getIt.get<ApiService>(),
            ),
          ),
        ),
        BlocProvider(
          create: (context) => DriverStatusCubit(
            DriverStatusRepositoryImpl(
              getIt.get<ApiService>(),
            ),
          ),
        ),
        BlocProvider(
          create: (context) => ScheduledTripsCubit(
            RepoScheduledTripsImpl(
              getIt.get<ApiService>(),
            ),
          ),
        ),
        BlocProvider(
          create: (context) => AcceptTripCubit(
            AcceptTripRepoImpl(
              getIt.get<ApiService>(),
            ),
          ),
        ),
        BlocProvider(
          create: (context) => ScheduledAcceptTripCubit(
            ScheduledAcceptOrderRepoImpl(
              getIt.get<ApiService>(),
            ),
          ),
        ),
        BlocProvider(
          create: (context) => TripDetailsCubit(
            TripDetailsRepositoryImpl(
              getIt.get<ApiService>(),
            ),
          ),
        ),
        BlocProvider(
          create: (context) => SingleTripDetailsCubit(
            SingleTripDetailsRepositoryImpl(
              getIt.get<ApiService>(),
            ),
          ),
        ),
        BlocProvider(
          create: (context) => UpdateLanguageCubit(
            LanguageRepositoryImpl(
              getIt.get<ApiService>(),
            ),
          ),
        ),
        BlocProvider(
          create: (context) => NotificationCubit(
            NotificationRepositoryImpl(
              getIt.get<ApiService>(),
            ),
          ),
        ),
        BlocProvider(
          create: (context) => WalletCubit(
            WalletRepositoryImpl(
              getIt.get<ApiService>(),
            ),
          ),
        ),
        BlocProvider(
          create: (context) => AddRatingCubit(
            AddRatingRepoImpl(
              getIt.get<ApiService>(),
            ),
          ),
        ),
        BlocProvider(
          create: (context) => GetFinishedTripsCubit(
            GetFinishedTripsRepoImpl(
              getIt.get<ApiService>(),
            ),
          ),
        ),
        BlocProvider(
          create: (context) => ProfileCubit(
            ImplementRepoProfile(
              apiService: getIt.get<ApiService>(),
            ),
          ),
        ),
        BlocProvider(
          create: (context) => DriverLocationCubit(
            DriverLocationRepositoryImpl(
              getIt.get<ApiService>(),
            ),
          ),
        ),
        BlocProvider(
          create: (context) => UpdateProfileCubit(
            UpdateProfileRepoImpl(
              getIt.get<ApiService>(),
            ),
          ),
        ),
        BlocProvider(
          create: (context) => ChangePasswordCubit(
            ChangePasswordRepoImpl(
              getIt.get<ApiService>(),
            ),
          ),
        ),
        BlocProvider(
          create: (context) => UpdateMobileCubit(
            RepoUpdateMobileImpl(
              getIt.get<ApiService>(),
            ),
          ),
        ),
        BlocProvider(
          create: (context) => StartTripCubit(
            TripRepositoryImpl(
              getIt.get<ApiService>(),
            ),
          ),
        ),
        BlocProvider(
          create: (context) => TripNoteCubit(
            TripNoteRepositoryImpl(
              getIt.get<ApiService>(),
            ),
          ),
        ),
        BlocProvider(
          create: (context) => GetStartedTripsCubit(
            GetStartedTripsRepositoryImpl(
              getIt.get<ApiService>(),
            ),
          ),
        ),
        BlocProvider(
          create: (context) => AddComplainCubit(
            AddComplainRepositoryImpl(
              getIt.get<ApiService>(),
            ),
          ),
        ),
        BlocProvider(
          create: (context) => EndTripCubit(
            EndTripRepositoryImpl(
              getIt.get<ApiService>(),
            ),
          ),
        ),
        BlocProvider<LanguageCubit>(create: (_) => LanguageCubit()),
      ],
      child: BlocBuilder<LanguageCubit, Language>(
        builder: (context, language) {
          Locale currentLocale;
          TextDirection currentDirection;
          context.read<LanguageCubit>().setLanguage(language);

          switch (language) {
            case Language.english:
              currentLocale = const Locale('en');
              currentDirection = TextDirection.rtl;
              break;
            case Language.kurdish:
              currentLocale = const Locale('ku');
              currentDirection = TextDirection.rtl;
              break;
            case Language.arabic:
              currentLocale = const Locale('ar');
              currentDirection = TextDirection.ltr;
              break;
          }

          return ScreenUtilInit(
            designSize: const Size(375, 866),
            minTextAdapt: true,
            splitScreenMode: true,
            child: MaterialApp(
              navigatorKey: navigatorKey,
              debugShowCheckedModeBanner: false,
              title: 'Warr App',
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
                KurdishMaterialLocalizationsDelegate(),
                KurdishCupertinoLocalizationsDelegate(),
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

class KurdishMaterialLocalizationsDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  const KurdishMaterialLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'ku';

  @override
  Future<MaterialLocalizations> load(Locale locale) async {
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
