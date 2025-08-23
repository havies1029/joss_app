import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:joss_app/blocs/networkconnection/network_bloc.dart';

class NetworkHelper {

  static void observeNetwork() {
    Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> result) {
      if (result.contains(ConnectivityResult.none)) {
        NetworkBloc().add(NetworkNotify());
      } else {
        NetworkBloc().add(NetworkNotify(isConnected: true));
      }
    });
  }
}

