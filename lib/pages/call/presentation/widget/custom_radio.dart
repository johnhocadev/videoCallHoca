import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:video_call_app/core/constant/typedefs/typedef.dart';

class CustomRadio extends StatelessWidget {
  const CustomRadio({
    required this.clientValue,
    required this.clientGroupValue,
    required this.updateRole,
    required this.title,
    super.key,
  });

  final ClientRoleType clientValue;
  final ClientRoleType clientGroupValue;
  final UpdateRole updateRole;
  final String title;

  @override
  Widget build(BuildContext context) {
    return RadioListTile(
      value: clientValue,
      groupValue: clientGroupValue,
      onChanged: (ClientRoleType? role) => updateRole(role),
      title: Text('$title'),
    );
  }
}
