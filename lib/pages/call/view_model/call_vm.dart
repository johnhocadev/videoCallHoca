import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

class CallVM extends ChangeNotifier {
  final TextEditingController _channelController = TextEditingController();
  bool _validator = false;
  ClientRoleType _role = ClientRoleType.clientRoleBroadcaster;
  bool _switcher = false;

  TextEditingController get channelController => _channelController;
  bool get validator => _validator;
  ClientRoleType get role => _role;
  bool get switcher => _switcher;
  // Setter for switcher
  set switcher(bool value) {
    _switcher = value;
    notifyListeners();
  }

  void updateValidator(bool validator) {
    _validator = validator;
    notifyListeners();
  }

  void updateRole(ClientRoleType? role) {
    _role = role ?? ClientRoleType.clientRoleBroadcaster;
    notifyListeners();
  }

  void updateSwitcher(bool value) {
    _switcher = value;
    notifyListeners();
  }


  @override
  void dispose() {
    _channelController.dispose();
    super.dispose();
  }
}

