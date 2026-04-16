import 'package:dartz/dartz.dart';
import 'package:drever_warr/core/service/api_servise.dart';
import 'package:drever_warr/core/service/failear.dart';
import 'package:drever_warr/features/home/preasntaion/data/cubit/model/wallat_model.dart';
import 'package:drever_warr/features/home/preasntaion/data/cubit/repo/repo_wallat/repo.dart';
import 'dart:developer' as dev;

class WalletRepositoryImpl implements WalletRepository {
  final ApiService apiService;

  WalletRepositoryImpl(this.apiService);

  @override
  Future<Either<Failur, WalletResponseModel>> getWalletOperations() async {
    try {
      dev.log(
        '🚀 [GET Request] بدء جلب عمليات المحفظة من السيرفر...',
        name: 'WalletRepo',
      );

      var response = await apiService.get(
        endpoint: 'balance-operations/driver',
        needToken: true,
      );

      
      dev.log('✅ [Raw Response]: ${response.data}', name: 'WalletRepo');

      
      final walletData = WalletResponseModel.fromJson(response.data);

    
      dev.log(
        '💰 [Driver Total Balance]: ${walletData.driverBalance}',
        name: 'WalletRepo',
      );
      dev.log(
        '📦 [Operations Count]: ${walletData.operations.length}',
        name: 'WalletRepo',
      );

      return right(walletData);
    } catch (e) {
    
      dev.log('❌ [Catch Error]: ${e.toString()}', name: 'WalletRepo', error: e);

      return left(ServierFailur(e.toString(), 500));
    }
  }
}
