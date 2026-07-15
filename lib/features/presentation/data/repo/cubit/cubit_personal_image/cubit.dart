import 'dart:io';
import 'package:drever_warr/features/presentation/data/repo/cubit/cubit_personal_image/cubit_stat.dart';
import 'package:drever_warr/features/presentation/data/repo/repo/repo_personal_image/repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class UploadImageCubit extends Cubit<UploadImageState> {
  final RepoUploadImage repo;
  UploadImageCubit(this.repo) : super(UploadImageInitial());

  File? selectedImage;

  
  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      selectedImage = File(pickedFile.path);
      
    }
  }

 
  Future<void> uploadImage() async {
    if (selectedImage == null) {
      emit(UploadImageFailure("يرجى اختيار صورة أولاً"));
      return;
    }

    emit(UploadImageLoading());

    var result = await repo.uploadDriverImage(imageFile: selectedImage!);

    result.fold(
      (failure) => emit(UploadImageFailure(failure.errMessage)),
      (success) => emit(UploadImageSuccess(success)),
    );
  }
}