import 'package:dartz/dartz.dart';
import 'package:drever_warr/core/service/failear.dart';
import 'package:drever_warr/features/home/preasntaion/data/cubit/model/wallat_model.dart';

 

abstract class WalletRepository {
   
  Future<Either<Failur, WalletResponseModel>> getWalletOperations();
}