import 'dart:io';
import 'package:drever_warr/features/preasntaion/data/repo/cubit/cubit_car_image/cubit_stat.dart';
import 'package:drever_warr/features/preasntaion/data/repo/repo/repo_car_image/repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
 
class UploadIdCubit extends Cubit<UploadIdState> {
  final RepoUploadId repo;
  UploadIdCubit(this.repo) : super(UploadIdInitial());

  File? frontImage;
  File? backImage;

  
  Future<void> uploadIdImages() async {
    if (frontImage == null || backImage == null) {
      emit(UploadIdFailure("يرجى اختيار صورة الوجه الأمامي والخلفي للهوية"));
      return;
    }

    emit(UploadIdLoading());

    var result = await repo.uploadDriverIdImages(
      frontImage: frontImage!,
      backImage: backImage!,
    );

    result.fold(
      (failure) {
        print("📢 [CUBIT ERROR]: ${failure.errMassage}");
        emit(UploadIdFailure(failure.errMassage));
      },
      (success) {
        print("📢 [CUBIT SUCCESS]: ID Uploaded Successfully");
        emit(UploadIdSuccess(success));
      },
    );
  }
}