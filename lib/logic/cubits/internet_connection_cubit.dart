import 'package:bloc/bloc.dart';
import '../states/internet_connection_states.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class ConnectionCubit extends Cubit<InternectConnectionState> {
  ConnectionCubit() : super(InternetConnctionIntialState());

  bool? isConnected;

  void checkConnction() {
    var listener = InternetConnectionChecker().onStatusChange.listen((status) {
      switch (status) {
        case InternetConnectionStatus.connected:
          isConnected = true;
          emit(InternetState());
          break;
        case InternetConnectionStatus.disconnected:
          emit(NoInternetState());
          isConnected = false;
          break;
      }
    });
  }

  void disposeConnectionlistner() async {
    await Future.delayed(Duration(seconds: 30));
    //await listener.cancel();
  }
}
