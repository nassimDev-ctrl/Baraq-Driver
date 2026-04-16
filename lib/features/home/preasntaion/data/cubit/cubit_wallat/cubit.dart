import 'package:drever_warr/features/home/preasntaion/data/cubit/cubit_wallat/cubit_stat.dart';
import 'package:drever_warr/features/home/preasntaion/data/cubit/repo/repo_wallat/repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WalletCubit extends Cubit<WalletState> {
  final WalletRepository walletRepository;

  WalletCubit(this.walletRepository) : super(WalletInitial());

  
Future<void> fetchWalletOperations() async {
  emit(WalletLoading());
  var result = await walletRepository.getWalletOperations();
  
  result.fold(
    (failure) => emit(WalletFailure(failure.errMassage)),  
    (walletResponse) => emit(WalletSuccess(walletResponse)),  
  );
}
}