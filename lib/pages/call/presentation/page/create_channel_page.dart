import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:video_call_app/core/constant/data/app_data.dart';
import 'package:video_call_app/pages/call/presentation/widget/pre_joining_dialog.dart';
import 'package:video_call_app/pages/call/utils/utils.dart';
import 'package:video_call_app/pages/call/view_model/provider/channel_state_provider.dart';

class CreateChannelPage extends ConsumerStatefulWidget {
  const CreateChannelPage({super.key});

  @override
  ConsumerState<CreateChannelPage> createState() => _CreateChannelPageState();
}

class _CreateChannelPageState extends ConsumerState<CreateChannelPage> {
  final _formKey = GlobalKey<FormState>();

  late final FocusNode _unfocusNode;
  late final TextEditingController _channelNameController;

  @override
  void initState() {
    super.initState();
    _unfocusNode = FocusNode();
    _channelNameController = TextEditingController();
  }

  Future<void> _joinRoom() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    FocusScope.of(context).requestFocus(_unfocusNode);

    final channelState = ref.read(channelStateProvider.notifier);
    channelState.setIsCreatingChannel(true);
    await channelState.getPermissions();

    try {
      final token = Constants().token;

      await Future.delayed(
        const Duration(seconds: 1),
      );

      if (context.mounted) {
        await showDialog(
          context: context,
          builder: (context) => PreJoiningDialog(
            channelName: _channelNameController.text,
            token: token,
          ),
        );
      }
    } catch (e) {
      showSnackBar(
        context,
        'Error generating token: $e',
      );
    } finally {
      channelState.setIsCreatingChannel(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final channelState = ref.watch(channelStateProvider);

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(_unfocusNode),
      child: Scaffold(
        body: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(top: 50),
              width: screenSize.width,
              constraints: const BoxConstraints(maxWidth: 600),
              child: Padding(
                padding:
                    const EdgeInsetsDirectional.symmetric(horizontal: 24.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                          0.0,
                          30.0,
                          0.0,
                          8.0,
                        ),
                        child: Text(
                          'Create Channel',
                          style: TextStyle(
                            fontSize: 32.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsetsDirectional.only(bottom: 24.0),
                        child: Text(
                          'Enter a channel name to generate token. The token will be valid for 1 hour.',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16.0,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                      Form(
                        key: _formKey,
                        child: TextFormField(
                          autofocus: true,
                          controller: _channelNameController,
                          obscureText: false,
                          decoration: InputDecoration(
                            labelText: 'Channel Name',
                            labelStyle: const TextStyle(
                              color: Colors.blue,
                              fontSize: 16.0,
                              fontWeight: FontWeight.normal,
                            ),
                            hintText: 'Enter your channel name...',
                            hintStyle: const TextStyle(
                              color: Color(0xFF57636C),
                              fontSize: 16.0,
                              fontWeight: FontWeight.normal,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.blue,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.blue,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.red,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.red,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                            fontWeight: FontWeight.normal,
                          ),
                          keyboardType: TextInputType.text,
                          validator: channelNameValidator,
                        ),
                      ),
                      const SizedBox(height: 24.0),
                      channelState
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [CircularProgressIndicator()],
                            )
                          : SizedBox(
                              width: double.infinity,
                              height: 55,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                ),
                                onPressed: _joinRoom,
                                child: const Text('Join Room'),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
