import 'package:dartz/dartz.dart';
import 'package:drever_warr/core/service/failure.dart';
import 'package:drever_warr/features/home/presentation/data/cubit/model/wallat_model.dart';

 

abstract class WalletRepository {
   
  Future<Either<Failure, WalletResponseModel>> getWalletOperations();
}