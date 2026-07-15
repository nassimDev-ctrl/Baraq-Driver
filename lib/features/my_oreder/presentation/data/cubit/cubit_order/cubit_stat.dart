import 'package:drever_warr/features/my_oreder/presentation/data/cubit/model/order_model.dart';

abstract class SearchingTripsState {}

class SearchingTripsInitial extends SearchingTripsState {}

class SearchingTripsLoading extends SearchingTripsState {}

class SearchingTripsSuccess extends SearchingTripsState {
  final List<TripModel> trips;  
  SearchingTripsSuccess(this.trips);
}

class SearchingTripsFailure extends SearchingTripsState {
  final String errMessage;
  SearchingTripsFailure(this.errMessage);
}