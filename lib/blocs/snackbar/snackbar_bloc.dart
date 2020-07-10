import 'package:bloc/bloc.dart';
import 'package:newsapp/blocs/snackbar/snackbar_event.dart';
import 'package:newsapp/blocs/snackbar/snackbar_state.dart';

class SnackBarBloc extends Bloc<SnackBarEvent, SnackBarState> {
  SnackBarBloc() : super(InitialSnackBar());

  @override
  Stream<SnackBarState> mapEventToState(SnackBarEvent event) async*{
    if (event is SuccessSnackBarEvent) {
      yield SuccessSnackBar(event.title);
    }
    if (event is FailedSnackBarEvent) {
      yield FailedSnackBar(event.title);
    }
  }
}