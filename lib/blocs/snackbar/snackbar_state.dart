abstract class SnackBarState {}

class SuccessSnackBar extends SnackBarState {
  final String title;

  SuccessSnackBar(this.title);
}

class FailedSnackBar extends SnackBarState {
  final String title;

  FailedSnackBar(this.title);
}

class InitialSnackBar extends SnackBarState {}