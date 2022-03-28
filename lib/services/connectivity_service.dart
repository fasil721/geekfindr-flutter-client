import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:geek_findr/constants.dart';
import 'package:geek_findr/main.dart';
import 'package:geek_findr/views/components/no_interner_page.dart';
import 'package:get/get.dart';

class ConnectivityService {
  final _connectivity = Connectivity();
  final connectivityStream = StreamController<ConnectivityResult>();

  ConnectivityService() {
    _connectivity.onConnectivityChanged.listen((event) {
      connectivityStream.add(event);
    });
  }
  void checkConnection() {
    final _connectivityService = ConnectivityService();
    _connectivityService.connectivityStream.stream.listen((event) async {
      if (event == ConnectivityResult.none) {
        controller.isOffline = true;
        controller.update(["home"]);
      } else {
        controller.isOffline = false;
        controller.update(["home"]);

      }
    });
  }
}
