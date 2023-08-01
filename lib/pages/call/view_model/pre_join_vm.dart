import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_call_app/core/constant/data/app_data.dart';
import 'package:video_call_app/pages/call/presentation/page/video_call_page.dart';


class PreJoiningDialogNotifier extends ChangeNotifier {
  bool _isMicEnabled = false;
  bool _isCameraEnabled = false;
  bool _isJoining = false;

  bool get isMicEnabled => _isMicEnabled;
  bool get isCameraEnabled => _isCameraEnabled;
  set isMicEnabled(bool value) {
    _isMicEnabled = value;
    notifyListeners();
  }

  set isCameraEnabled(bool value) {
    _isCameraEnabled = value;
    notifyListeners();
  }
  bool get isJoining => _isJoining;

  Future<void> getPermissions() async {
    await getMicPermissions();
    await getCameraPermissions();
  }

  Future<void> getMicPermissions() async {
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      final micPermission = await Permission.microphone.request();
      if (micPermission == PermissionStatus.granted) {
        _isMicEnabled = true;
      }
    } else {
      _isMicEnabled = !_isMicEnabled;
    }
    notifyListeners();
  }

  Future<void> getCameraPermissions() async {
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      final cameraPermission = await Permission.camera.request();
      if (cameraPermission == PermissionStatus.granted) {
        _isCameraEnabled = true;
      }
    } else {
      _isCameraEnabled = !_isCameraEnabled;
    }
    notifyListeners();
  }

  Future<void> joinCall({required BuildContext context,required channelName,required String token}) async {
    _isJoining = true;
    notifyListeners();

    final appId = Constants().appId;

    _isJoining = false;
    if (context.mounted) {
      Navigator.of(context).pop();
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => VideoCallPage(
            appId: appId,
            token: token,
            channelName: channelName,
            isMicEnabled: _isMicEnabled,
            isVideoEnabled: _isCameraEnabled,
          ),
        ),
      );
    }
  }
}