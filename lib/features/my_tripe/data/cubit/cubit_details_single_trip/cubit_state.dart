import 'package:drever_warr/features/home/preasntaion/data/cubit/model/model_finsh_trips.dart';
import 'package:drever_warr/features/my_tripe/data/model/single_finished_trip.dart';

abstract class SingleTripDetailsState {}

class SingleTripDetailsInitial extends SingleTripDetailsState {}

class SingleTripDetailsLoading extends SingleTripDetailsState {}

class SingleTripDetailsSuccess extends SingleTripDetailsState {
  final SingleFinishedTripModel trip;
  SingleTripDetailsSuccess(this.trip);
}

class SingleTripDetailsFailure extends SingleTripDetailsState {
  final String errMessage;
  SingleTripDetailsFailure(this.errMessage);
}