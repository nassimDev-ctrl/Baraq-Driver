import 'dart:developer';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TripSocketService {
  late IO.Socket socket;
  final String serverUrl = 'https://api.taxiwaar.com';

  void connect(String token) {
    print(
      "---------------- [🔌 ATTEMPTING SOCKET CONNECTION] ----------------",
    );
    print("🔑 Using Token: ${token.substring(0, 10)}...");

  
    socket = IO.io(
      serverUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])  
          .setAuth({'token': token}) 
          .enableAutoConnect()  
          .build(),
    );

  

    socket.onConnect((_) {
      print('✅ [SOCKET] Connected Successfully to: $serverUrl');
      print('🆔 [SOCKET] Connection ID: ${socket.id}');
    });

    socket.onConnectError((data) {
      print('❌ [SOCKET] Connection Error: $data');
    });

  
    socket.on('connect_timeout', (data) {
      print('⏰ [SOCKET] Connection Timeout: $data');
    });

    socket.onError((data) {
      print('🚨 [SOCKET] General Error: $data');
    });

    socket.onDisconnect((reason) {
      print('🚫 [SOCKET] Disconnected. Reason: $reason');
    });
  }

 
  void joinTrip(String tripId) {
    print('📦 [EMIT] Joining Room for Trip ID: $tripId');
    socket.emit('join_trip', {'tripId': tripId});

    socket.on('joined_room', (data) {
      print('📥 [RECEIVE] Successfully Joined Room: $data');
    });
  }

  
  void sendLocation({required String tripId, required LatLng location}) {
    var locationData = {
      'tripId': tripId,
      'location': {'lat': location.latitude, 'lng': location.longitude},
    };

    print('📡 [EMIT] driver_location: $locationData');
    socket.emit('driver_location', locationData);
  }

  
  void listenToLocationUpdates(Function(dynamic) onLocationUpdate) {
    socket.on('driver_location_update', (data) {
      print('📍 [RECEIVE] driver_location_update: $data');
      onLocationUpdate(data);
    });
  }

   
  void listenToEmergency(Function(dynamic) onEmergency) {
    socket.on('emergency_activated', (data) {
      print("🚨 [RECEIVE] EMERGENCY_ACTIVATED: $data");
      onEmergency(data);
    });
  }

  // 5. الاستماع لانتهاء الرحلة
  void listenToTripCompleted(Function(dynamic) onComplete) {
    socket.on('trip_completed', (data) {
      print("🏁 [RECEIVE] TRIP_COMPLETED: $data");
      onComplete(data);
    });
  }

  // 6. إرسال حالة طوارئ
  void sendEmergency({
    required String tripId,
    required LatLng location,
    required String userId,
  }) {
    var emergencyData = {
      'tripId': tripId,
      'location': {'lat': location.latitude, 'lng': location.longitude},
      'userId': userId,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };

    print('🆘 [EMIT] Sending SOS: $emergencyData');
    socket.emit('emergency_location', emergencyData);
  }

  // تنظيف الاتصال
  void dispose(String tripId) {
    print('🔌 [DISPOSE] Leaving trip and closing socket for ID: $tripId');
    socket.emit('leave_trip', {'tripId': tripId});
    socket.dispose();
  }
}
