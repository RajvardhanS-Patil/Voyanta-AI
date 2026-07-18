import 'dart:async';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ConnectionStatus { online, offline, weak }

class ConnectivityService extends Notifier<ConnectionStatus> {
  Timer? _timer;

  @override
  ConnectionStatus build() {
    ref.onDispose(() {
      _timer?.cancel();
    });
    _startPingTimer();
    return ConnectionStatus.online;
  }

  void _startPingTimer() {
    _timer = Timer.periodic(
      const Duration(seconds: 12),
      (_) => checkConnection(),
    );
    checkConnection();
  }

  Future<void> checkConnection() async {
    try {
      final stopwatch = Stopwatch()..start();
      // Verify genuine internet backhaul with ping timeout
      final result = await InternetAddress.lookup(
        'google.com',
      ).timeout(const Duration(seconds: 4));
      stopwatch.stop();

      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        if (stopwatch.elapsedMilliseconds > 1800) {
          state = ConnectionStatus.weak;
        } else {
          state = ConnectionStatus.online;
        }
      } else {
        state = ConnectionStatus.offline;
      }
    } catch (_) {
      state = ConnectionStatus.offline;
    }
  }
}

final connectivityServiceProvider =
    NotifierProvider<ConnectivityService, ConnectionStatus>(() {
      return ConnectivityService();
    });
