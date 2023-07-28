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
  List<Color> colorList = [
    Color(0xffFF0000),
    Color(0xff410D75),
    Color(0xffFF0000),
    Color(0xff050340),
    Color(0xffFF0000),
  ];
  int index = 0;
  Color bottomColor = Color(0xff092646);
  Color topColor = Color(0xff410D75);
  Alignment begin = Alignment.bottomCenter;
  Alignment end = Alignment.topCenter;

  void updateColors() {
    index = index + 1;
    bottomColor = colorList[index % colorList.length];
    topColor = colorList[(index + 1) % colorList.length];
    notifyListeners();
  }
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

