
import '../model/update_location_response_model.dart';

abstract class DriverLocationState {}

class DriverLocationInitial extends DriverLocationState {}

class DriverLocationLoading extends DriverLocationState {}

class DriverLocationSuccess extends DriverLocationState {
  final UpdateLocationResponseModel driverData;
  DriverLocationSuccess(this.driverData);
}

class DriverLocationFailure extends DriverLocationState {
  final String errMessage;
  DriverLocationFailure(this.errMessage);
}