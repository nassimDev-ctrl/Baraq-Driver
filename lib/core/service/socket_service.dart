import 'dart:developer';

import 'package:drever_warr/core/constant/api_constants.dart';
import 'package:drever_warr/core/logging/app_logger.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class TripSocketService {
  late io.Socket socket;
  final String serverUrl = ApiConstants.baseUrl.replaceAll(RegExp(r'/$'), '');

  void connect(String token) {
    socket = io.io(
      serverUrl,
      io.OptionBuilder()
          .setTransports(['websocket'])
          .setAuth({'token': token})
          .enableAutoConnect()
          .build(),
    );

    socket.onConnect((_) {
      log('✅ [SOCKET] Connected: ${socket.id}');
    });

    socket.onConnectError((data) {
      log('❌ [SOCKET] Connect error: $data');
    });

    socket.onError((data) {
      log('🚨 [SOCKET] Error: $data');
    });

    socket.onDisconnect((reason) {
      log('🚫 [SOCKET] Disconnected: $reason');
    });
  }

  // =========================
  // JOIN TRIP
  // =========================
  void joinTrip(String tripId) {
    log('📦 [EMIT] join_trip -> $tripId');
    socket.emit('join_trip', {'tripId': tripId});
  }

  // =========================
  // DRIVER LOCATION
  // =========================
  void sendLocation({
    required String tripId,
    required LatLng location,
  }) {
    final payload = {
      'tripId': tripId,
      'location': {
        'lat': location.latitude,
        'lng': location.longitude,
      },
    };

    log('📡 [EMIT] driver_location -> $payload');
    socket.emit('driver_location', payload);
  }

  // =========================
  // EMERGENCY LOCATION
  // =========================
  void sendEmergency({
    required String tripId,
    required LatLng location,
    required String userId,
  }) {
    final payload = {
      'tripId': tripId,
      'location': {
        'lat': location.latitude,
        'lng': location.longitude,
      },
      'userId': userId,
    };

    log('🆘 [EMIT] emergency_location -> $payload');
    socket.emit('emergency_location', payload);
  }

  // =========================
  // EMERGENCY STOP
  // =========================
  void stopEmergency({
    required String tripId,
    required String userId,
  }) {
    final payload = {
      'tripId': tripId,
      'userId': userId,
    };

    log('🛑 [EMIT] emergency_stop -> $payload');
    socket.emit('emergency_stop', payload);
  }

  // =========================
  // TRIP COMPLETED
  // This is an INBOUND handler on the backend,
  // so the client should EMIT it when the trip ends.
  // =========================
  void completeTrip(String tripId) {
    log('🏁 [EMIT] trip_completed -> $tripId');
    socket.emit('trip_completed', {'tripId': tripId});
  }

  // =========================
  // LISTENERS
  // =========================

  void listenToDriverLocationUpdates(Function(dynamic data) onUpdate) {
    socket.off('driver_location_update');
    socket.on('driver_location_update', (data) {
      log('📍 [RECEIVE] driver_location_update -> $data');
      onUpdate(data);
    });
  }

  void listenToTripPaths(Function(dynamic data) onPaths) {
    socket.off('trip_paths');
    socket.on('trip_paths', (data) {
      log('🗺️ [RECEIVE] trip_paths -> $data');
      onPaths(data);
    });
  }

  void listenToEmergencyActivated(Function(dynamic data) onEmergency) {
    socket.off('emergency_activated');
    socket.on('emergency_activated', (data) {
      log('🚨 [RECEIVE] emergency_activated -> $data');
      onEmergency(data);
    });
  }

  void listenToEmergencyLocationUpdates(Function(dynamic data) onUpdate) {
    socket.off('emergency_location_update');
    socket.on('emergency_location_update', (data) {
      log('🚑 [RECEIVE] emergency_location_update -> $data');
      onUpdate(data);
    });
  }

  void listenToEmergencyStopped(Function(dynamic data) onStopped) {
    socket.off('emergency_stopped');
    socket.on('emergency_stopped', (data) {
      log('✅ [RECEIVE] emergency_stopped -> $data');
      onStopped(data);
    });
  }

  void listenToNewMessages(Function(dynamic data) onMessage) {
    socket.off("new:message");
    socket.on("new:message", (data) {
      AppLogger.debug("New Message: $data");
      onMessage(data);
    });
  }

  // The backend does NOT emit joined_room.
  // If you need a join confirmation, use trip_paths / driver_location_update
  // or add a socket.emit callback on the server.
  // =========================
  // DISPOSE
  // =========================
  void dispose() {
    try {
      socket.disconnect();
      socket.dispose();
      log('🔌 [SOCKET] disposed');
    } catch (e) {
      log('⚠️ [SOCKET] dispose error: $e');
    }
  }
}
