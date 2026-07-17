import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/translate/app_translate.dart';
import 'package:drever_warr/core/widgets/auth/auth_ui_constants.dart';
import 'package:drever_warr/features/home/presentation/data/cubit/cubit_wallat/cubit.dart';
import 'package:drever_warr/features/home/presentation/data/cubit/cubit_wallat/cubit_stat.dart';
import 'package:drever_warr/features/home/presentation/data/cubit/model/wallat_model.dart';
import 'package:drever_warr/features/home/presentation/widget/wallet/balance_card.dart';
import 'package:drever_warr/features/home/presentation/widget/wallet/quick_actions_section.dart';
import 'package:drever_warr/features/home/presentation/widget/wallet/statistics_section.dart';
import 'package:drever_warr/features/home/presentation/widget/wallet/transaction_history_section.dart';
import 'package:drever_warr/features/home/presentation/widget/wallet/wallet_header.dart';
import 'package:drever_warr/features/home/presentation/widget/wallet/wallet_ui_constants.dart';
import 'package:drever_warr/features/home/presentation/widget/wallet/withdraw_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  @override
  void initState() {
    super.initState();
    context.read<WalletCubit>().fetchWalletOperations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      body: BlocBuilder<WalletCubit, WalletState>(
        builder: (context, state) {
          final isLoading = state is WalletLoading || state is WalletInitial;
          final walletData = state is WalletSuccess ? state.walletData : null;

          return Column(
            children: [
              Expanded(
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          const WalletHeader(),
                          Positioned(
                            left: WalletUiConstants.horizontalPadding.w,
                            right: WalletUiConstants.horizontalPadding.w,
                            bottom: -WalletUiConstants.balanceCardOverlap.h,
                            child: BalanceCard(
                              balance: walletData?.driverBalance ?? 0,
                              isLoading: isLoading && walletData == null,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: (WalletUiConstants.balanceCardOverlap + 20).h,
                      ),
                    ),
                    SliverPadding(
                      padding: EdgeInsets.symmetric(
                        horizontal: WalletUiConstants.horizontalPadding.w,
                      ),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          if (state is WalletFailure)
                            _WalletErrorState(
                              message: state.errMessage,
                              onRetry: () => context
                                  .read<WalletCubit>()
                                  .fetchWalletOperations(),
                            )
                          else ...[
                            const QuickActionsSection(),
                            SizedBox(height: WalletUiConstants.sectionSpacing.h),
                            StatisticsSection(
                              operations: walletData?.operations ??
                                  const <WalletOperationModel>[],
                            ),
                            SizedBox(height: WalletUiConstants.sectionSpacing.h),
                            if (isLoading && walletData == null)
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 40.h),
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors.main1,
                                  ),
                                ),
                              )
                            else
                              TransactionHistorySection(
                                operations: walletData?.operations ??
                                    const <WalletOperationModel>[],
                              ),
                          ],
                          SizedBox(height: 24.h),
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
              const WithdrawButton(),
            ],
          );
        },
      ),
    );
  }
}

class _WalletErrorState extends StatelessWidget {
  const _WalletErrorState({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 36.h, horizontal: 20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22.r),
        boxShadow: WalletUiConstants.cardShadow,
      ),
      child: Column(
        children: [
          Icon(
            Icons.wifi_off_rounded,
            size: 40.sp,
            color: AuthUiConstants.iconMuted,
          ),
          SizedBox(height: 12.h),
          Text(
            message.isNotEmpty
                ? message
                : AppTranslations.getText(context, 'error_occurred'),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AuthUiConstants.textPrimary,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 16.h),
          TextButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded),
            label: Text(AppTranslations.getText(context, 'retry')),
            style: TextButton.styleFrom(foregroundColor: AppColors.main1),
          ),
        ],
      ),
    );
  }
}
