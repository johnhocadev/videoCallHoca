import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../channel_state_vm.dart';

final channelStateProvider = StateNotifierProvider<ChannelState, bool>((ref) => ChannelState());

