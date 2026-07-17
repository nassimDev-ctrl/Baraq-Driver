import 'package:drever_warr/core/di/app_providers.dart';
import 'package:drever_warr/features/home/presentation/view/home_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Authenticated shell: home-session cubits + nested [Navigator] so pushed
/// routes (wallet, orders, settings, …) still inherit those providers.
class HomeSession extends StatelessWidget {
  const HomeSession({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: homeSessionProviders,
      child: Navigator(
        onGenerateInitialRoutes: (navigator, initialRoute) {
          return [
            MaterialPageRoute<void>(
              builder: (_) => const HomeView(),
            ),
          ];
        },
      ),
    );
  }
}
