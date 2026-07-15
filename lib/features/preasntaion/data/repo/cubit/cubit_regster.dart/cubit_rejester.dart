import 'package:drever_warr/features/preasntaion/data/repo/cubit/cubit_regster.dart/cubit_regster_state.dart';
import 'package:drever_warr/core/logging/app_logger.dart';

import 'package:drever_warr/features/preasntaion/data/repo/repo.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

 
class RegisterCubit extends Cubit<RegisterState> {
  final RepoRegister repo;

  RegisterCubit(this.repo) : super(RegisterInitial());

  Map<String, dynamic>? temporaryUserData;

  void setUserData({
    required String firstName,
    required String lastName,
    required String mobilePhone,
    required String governorateId,
    required String password,
    required String emergencyNumber,
    required String gender,
    required String addres,
    required double lat,
    required double lng,
  }) {
    temporaryUserData = {
      "firstName": firstName,
      "lastName": lastName,
      "mobilePhone": "963$mobilePhone",
      "city": governorateId,
      "gender": gender,
      "emergencyNumber": "963$emergencyNumber",
      "password": password,
      "userType": "driver",
      "address": {
        "type": "Point",
        "coordinates": [
          lat,
          lng,
        ],  
        "address": addres,
      },
    };

    AppLogger.debug("User Data Set: $temporaryUserData");
  }

  Future<void> registerUser({required String otp}) async {
    if (temporaryUserData == null) {
      emit(RegisterFailure("بيانات المستخدم مفقودة، يرجى المحاولة من جديد"));
      return;
    }

    emit(RegisterLoading());

    // دمج كود الـ OTP
    final Map<String, dynamic> finalData = {...temporaryUserData!, "code": otp};

    var result = await repo.register(userData: finalData);

    result.fold(
      (failure) => emit(RegisterFailure(failure.errMassage)),
      (success) => emit(RegisterSuccess(success)),
    );
  }
}