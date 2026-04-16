import 'package:drever_warr/features/home/preasntaion/data/cubit/model/model_finsh_trips.dart';
 
abstract class GetFinishedTripsState {}

class GetFinishedTripsInitial extends GetFinishedTripsState {}
class GetFinishedTripsLoading extends GetFinishedTripsState {}
class GetFinishedTripsSuccess extends GetFinishedTripsState {
  final List<FinishedTripModel> trips;
  GetFinishedTripsSuccess(this.trips);
}
class GetFinishedTripsFailure extends GetFinishedTripsState {
  final String errMessage;
  GetFinishedTripsFailure(this.errMessage);
}