import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:video_call_app/pages/main/view_model/main_vm.dart';

final  mainProvider = ChangeNotifierProvider((ref) => MainVM());
