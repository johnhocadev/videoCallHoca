import 'package:flutter/material.dart';
void showSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
    ),
  );
}

String? channelNameValidator(value) {
  if (value == null || value.isEmpty) {
    return 'Please enter a channel name';
  } else if (value.length > 64) {
    return 'Channel name must be less than 64 characters';
  }
  return null;
}


