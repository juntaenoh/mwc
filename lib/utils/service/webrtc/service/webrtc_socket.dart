import 'dart:async';
import 'package:mwc/index.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:flutter/material.dart';

class WebRTCSocket {
  late io.Socket _socket;
  String? user;

  Future<String?> connectSocket() {
    final Completer<String> completer = Completer<String>();
    // 서버 ip 설정 -> signal server ip
    _socket = io.io('http://webrtc.carencoinc.com:9000', io.OptionBuilder().setTransports(['websocket']).build());

    _socket.onConnect((data) {
      user = _socket.id;

      // completer가 아직 완료되지 않았는지 확인한 후 complete 호출
      if (!completer.isCompleted) {
        completer.complete(user);
        debugPrint('[socket] connected : $user');
      }
    });

    return completer.future;
  }

  void socketOn(String event, void Function(dynamic) callback) {
    _socket.on(event, callback);
  }

  void socketEmit(String event, dynamic data) {
    _socket.emit(event, data);
  }

  void disconnectSocket() {
    _socket.dispose();
  }
}

  // Future를 직접 반환하는 메소드
  // Future<String> getUserId() {
  //   return _completer.future;
  // }
