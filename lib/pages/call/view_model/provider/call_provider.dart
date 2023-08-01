import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:video_call_app/pages/call/view_model/call_vm.dart';

final  callProvider = ChangeNotifierProvider((ref) => CallVM());
