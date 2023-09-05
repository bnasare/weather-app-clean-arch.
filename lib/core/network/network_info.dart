import 'package:connectivity_plus/connectivity_plus.dart';

abstract class NetworkInfo {
  Future<bool>? isConnected();
}

class NetworkInfoImpl implements NetworkInfo {
  Connectivity connectivity = Connectivity();

  NetworkInfoImpl(this.connectivity);

  @override
  Future<bool>? isConnected() async {
    final connectivityResult = await connectivity.checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }
}
