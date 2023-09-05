import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:weather_app_clean_architecture/core/network/network_info.dart';

class MockConnectivityChecker extends Mock implements Connectivity {}

void main() {
  late NetworkInfoImpl networkInfoImpl;
  late MockConnectivityChecker mockConnectivityChecker;

  setUp(() {
    mockConnectivityChecker = MockConnectivityChecker();
    networkInfoImpl = NetworkInfoImpl(mockConnectivityChecker);
  });

  group('isConnected', () {
    test('should return true for WiFi network connection', () async {
      when(mockConnectivityChecker.checkConnectivity())
          .thenAnswer((_) async => ConnectivityResult.wifi);

      final result = await networkInfoImpl.isConnected();
      expect(result, true);
      verify(mockConnectivityChecker.checkConnectivity());
    });

    test('should return true for mobile network connection', () async {
      const tMobileConnection = ConnectivityResult.mobile;
      when(mockConnectivityChecker.checkConnectivity())
          .thenAnswer((_) => Future.value(tMobileConnection));

      final result = await networkInfoImpl.isConnected();
      expect(result, true);
      verify(mockConnectivityChecker.checkConnectivity());
    });

    test('should return true for other network connections', () async {
      when(mockConnectivityChecker.checkConnectivity())
          .thenAnswer((_) async => ConnectivityResult.other);

      final result = await networkInfoImpl.isConnected();
      expect(result, true);
      verify(mockConnectivityChecker.checkConnectivity());
    });
  });
}
