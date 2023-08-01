import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChannelState extends StateNotifier<bool> {
  ChannelState() : super(false);

  void setIsCreatingChannel(bool value) {
    state = value;
  }
}
