import 'package:drever_warr/features/my_tripe/data/cubit/cubit_ratting/cubit_stat.dart';
import 'package:drever_warr/features/my_tripe/data/repo/repo_rating/repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
  
class AddRatingCubit extends Cubit<AddRatingState> {
  final AddRatingRepo addRatingRepo;

  AddRatingCubit(this.addRatingRepo) : super(AddRatingInitial());

  Future<void> submitRating({
    required String tripId,
    required String note,
    required int rating,
  }) async {
    emit(AddRatingLoading());
    var result = await addRatingRepo.addRating(
      tripId: tripId,
      note: note,
      rating: rating,
    );

    result.fold(
      (failure) => emit(AddRatingFailure(failure.errMessage)),
      (data) => emit(AddRatingSuccess("تم إضافة التقييم بنجاح")),
    );
  }
}