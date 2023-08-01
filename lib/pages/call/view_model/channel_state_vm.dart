import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

class ChannelState extends StateNotifier<bool> {
  ChannelState() : super(false);

  Future<void> getPermissions() async {
    await getMicPermissions();
    await getCameraPermissions();
  }
  Future<void> getMicPermissions() async {
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      final micPermission = await Permission.microphone.request();
    }
  }

  Future<void> getCameraPermissions() async {
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      final cameraPermission = await Permission.camera.request();
    }
  }
  void setIsCreatingChannel(bool value) {
    state = value;
  }
}
