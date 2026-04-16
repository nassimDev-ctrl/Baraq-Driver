import 'package:drever_warr/features/home/preasntaion/data/cubit/model/wallat_model.dart';

abstract class WalletState {}

class WalletInitial extends WalletState {}
class WalletLoading extends WalletState {}
 
class WalletSuccess extends WalletState {
  final WalletResponseModel walletData;  
  WalletSuccess(this.walletData);
}
class WalletFailure extends WalletState {
  final String errMessage;
  WalletFailure(this.errMessage);
}