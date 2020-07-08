abstract class SnackBarEvent {}

class SuccessSnackBarEvent extends SnackBarEvent {
  final String title;

  SuccessSnackBarEvent(this.title);
}

class FailedSnackBarEvent extends SnackBarEvent {
  final String title;

  FailedSnackBarEvent(this.title);
}