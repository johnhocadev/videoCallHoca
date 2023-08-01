import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:video_call_app/pages/call/view_model/pre_join_vm.dart';

final preJoiningDialogProvider = ChangeNotifierProvider.autoDispose<PreJoiningDialogNotifier>((ref) => PreJoiningDialogNotifier());
