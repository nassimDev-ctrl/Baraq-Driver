 
import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/transleat/app_translat.dart';
import 'package:drever_warr/features/home/preasntaion/data/cubit/cubit_wallat/cubit.dart';
import 'package:drever_warr/features/home/preasntaion/data/cubit/cubit_wallat/cubit_stat.dart';
import 'package:drever_warr/features/home/preasntaion/widget/WalletTransactionCard.dart';
import 'package:drever_warr/features/preasntaion/widhets/icon_bak.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // أضف هذا
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocBuilder<WalletCubit, WalletState>(
          builder: (context, state) {
         
            String currentBalance = "...";
            if (state is WalletSuccess) {
              currentBalance = "${state.walletData.driverBalance} SYP";
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const IconBak(),
                SizedBox(height: 25.h),

               
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        AppTranslations.getText(context, "wallet_record"),
                        style: TextStyle(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.blue,
                        ),
                      ),
                      SizedBox(height: 30.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            currentBalance, 
                            style: TextStyle(
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.main1,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 40.h),
                      Text(
                        AppTranslations.getText(context, "current_balance"),
                        style: TextStyle(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.blue,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 10.h),

                
                Expanded(child: _buildListContent(state)),
              ],
            );
          },
        ),
      ),
    );
  }

  
  Widget _buildListContent(WalletState state) {
    if (state is WalletLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is WalletSuccess) {
      final operations = state.walletData.operations;
      if (operations.isEmpty) {
        return const Center(child: Text("لا يوجد عمليات حالياً"));
      }
      return ListView.builder(
        itemCount: operations.length,
        itemBuilder: (context, index) {
          final item = operations[index];
          return WalletTransactionCard(
            date: item.date.split('T')[0],
            amount: "${item.amount}",
            isCredit: item.type == 'charge',
          );
        },
      );
    } else if (state is WalletFailure) {
      return Center(child: Text(state.errMessage));
    }
    return const SizedBox();
  }
}
