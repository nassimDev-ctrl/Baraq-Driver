abstract class DriverStatusState {}

class DriverStatusInitial extends DriverStatusState {}

class DriverStatusLoading extends DriverStatusState {}

class DriverStatusLoaded extends DriverStatusState {
  final bool isAvailable;
  final bool isUpdating;

  DriverStatusLoaded({
    required this.isAvailable,
    this.isUpdating = false,
  });
}

class DriverStatusFailure extends DriverStatusState {
  final String errMessage;
  DriverStatusFailure(this.errMessage);
}