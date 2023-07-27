import 'package:firebase_auth/firebase_auth.dart';
import 'package:video_call_app/pages/authentication/authentication/authentication_model.dart';
import 'package:video_call_app/pages/editInfoPage/editInfoModel.dart';

import '/auth/firebase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';



class EditInfoWidget extends StatefulWidget {
  const EditInfoWidget({
    Key? key,
    String? userName,
  })  : this.userName = userName ?? 'userEmail',
        super(key: key);

  final String userName;

  @override
  _EditInfoWidgetState createState() => _EditInfoWidgetState();
}

class _EditInfoWidgetState extends State<EditInfoWidget>
    with TickerProviderStateMixin {
  late EditInfoModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
TextEditingController passController = TextEditingController();
  final animationsMap = {
    'buttonOnPageLoadAnimation': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        VisibilityEffect(duration: 400.ms),
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 400.ms,
          duration: 600.ms,
          begin: 0,
          end: 1,
        ),
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 400.ms,
          duration: 600.ms,
          begin: Offset(0, 60),
          end: Offset(0, 0),
        ),
      ],
    ),
  };
  
   /// 유저 이름 업데이트
  Future<void> updateProfileName(String name) async{
    final user = FirebaseAuth.instance.currentUser;
    await user?.updateDisplayName(name);
  }
  /// 유저 url 업데이트
  Future<void> updateProfilEmail(String url) async{
    final user = FirebaseAuth.instance.currentUser;
    await user?.updateEmail(url);
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => EditInfoModel());

    _model.textController1 ??= TextEditingController();
    _model.textController2 ??= TextEditingController();
    setupAnimations(
      animationsMap.values.where((anim) =>
          anim.trigger == AnimationTrigger.onActionTrigger ||
          !anim.applyInitialState),
      this,
    );
  }

  @override
  void dispose() {
    _model.dispose();

  super.dispose();
  }



Future<void> updateUserInformation(
  String displayName,
  String email,
  String password,
  String photoUrl,
) async {
  try {
    User? currentUser = FirebaseAuth.instance.currentUser;
    String userId = currentUser!.uid;

    // Step 1: Re-authenticate the user with their existing credentials
    AuthCredential credential = EmailAuthProvider.credential(email: currentUser.email!, password: password);
    await currentUser.reauthenticateWithCredential(credential);

    // Step 2: Update display name and photo URL in Firebase Authentication
    // ignore: deprecated_member_use
    await currentUser.updateProfile(displayName: displayName, photoURL: photoUrl);

    // Step 3: Update email if it has changed
    if (email != currentUser.email) {
      await currentUser.updateEmail(email);
    }

    // Step 4: Update password if it has changed
    if (password.isNotEmpty) {
      await currentUser.updatePassword(password);
    }

    // Step 5: Update user data in Firestore
    DocumentReference userDocRef = FirebaseFirestore.instance.collection('users').doc(userId);
    await userDocRef.update({
      'display_name': displayName,
      'email': email,
      'photo_url': photoUrl,
    });

    print('User information updated successfully.');
  } catch (e) {
    print('Error updating user information: $e');
    // Handle errors as per your app's requirements.
  }
}
  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(_model.unfocusNode),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        automaticallyImplyLeading: false,
        
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.black,),
            onPressed: () => context.pop(),
          ),
          title: Text(
            'Edit profile',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  fontFamily: 'Outfit',
                  color: Colors.black,
                  fontSize: 22,
                ),
          ),
          actions: [],
          centerTitle: true,
          elevation: 0,
        ),
        body: SafeArea(
          top: true,
          child: Stack(
            children: [
              Align(
                alignment: AlignmentDirectional(0, -1.05),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Align(
                        alignment: AlignmentDirectional(0, 0),
                        child: Padding(
                          padding:
                              EdgeInsetsDirectional.fromSTEB(15, 60, 15, 0),
                          child: TextFormField(
                            controller: _model.textController1,
                            autofocus: true,
                            obscureText: false,
                            decoration: InputDecoration(
                              labelText: 'Enter new username',
                              labelStyle:
                                  FlutterFlowTheme.of(context).labelMedium,
                              hintText: 'username',
                              hintStyle:
                                  FlutterFlowTheme.of(context).labelMedium,
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context).alternate,
                                  width: 3,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context).primary,
                                  width: 3,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context).error,
                                  width: 3,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context).error,
                                  width: 3,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              filled: true,
                            ),
                            style: FlutterFlowTheme.of(context).bodyMedium,
                            validator: _model.textController1Validator
                                .asValidator(context),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(15, 8, 15, 0),
                        child: TextFormField(
                          controller: _model.textController2,
                          autofocus: true,
                          obscureText: false,
                          decoration: InputDecoration(
                            labelText: 'Enter new email address',
                            labelStyle:
                                FlutterFlowTheme.of(context).labelMedium,
                            hintText: 'email',
                            hintStyle: FlutterFlowTheme.of(context).labelMedium,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).alternate,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).primary,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).error,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).error,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            filled: true,
                          ),
                          style: FlutterFlowTheme.of(context).bodyMedium,
                          validator: _model.textController2Validator
                              .asValidator(context),
                        ),
                      ),
                       Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(15, 8, 15, 0),
                        child: TextFormField(
                          controller: passController,
                          autofocus: true,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Enter new password',
                            labelStyle:
                                FlutterFlowTheme.of(context).labelMedium,
                            hintText: 'password',
                            hintStyle: FlutterFlowTheme.of(context).labelMedium,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).alternate,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).primary,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).error,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).error,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8), 
                            ),
                            filled: true,
                          ),
                          style: FlutterFlowTheme.of(context).bodyMedium,
                          // validator: _model.textController3Validator
                              // .asValidator(context),
                        ),
                      ),
                      // Container(
                      //   height: 100,
                      //   width: 100,
                      //   child: Icon(Icons.image),
                      // )
                    ],
                  ),
                ),
              ),
              Align(
                alignment: AlignmentDirectional(0, 0),
                child:    Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0, 300, 0, 0),
            child: FFButtonWidget(
              onPressed: () async {
                   if (_model.textController1.text.isNotEmpty && _model.textController2.text.isNotEmpty && passController.text.isNotEmpty){
                     showDialog(context: context, builder: (context){
                      return Container(
                        height: 200,
                        width: 200,
                        child: AlertDialog(
                          content: Text('Data saved'),
                          actions: [
                            TextButton(onPressed: (){
                             
                              context.pop();
                            
                            }, child: Text('Cancel')),
                                TextButton(onPressed: (){
                                 print('data saved');
                                 updateUserInformation(_model.textController1.text, _model.textController2.text, passController.text, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSg-3382ZgdUhzsOz0VYE8KVNtX_HTwTxRSps08Nli1&s');
                                 print(_model.textController3.text);
            //                      Future.delayed(Duration(seconds: 3), () {
            //                       Center(child: CircularProgressIndicator(),);
            // });
                 context.pop();
                              context.pushReplacementNamed('Main');
                           
                            }, child: Text('Save')),
                          ],
                          ),
                          
                      );
                    });
                   } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Fill both fields!')));
                   }
              },
              text: 'Save',
              options: FFButtonOptions(
                width: 190,
                height: 50,
                padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                color: FlutterFlowTheme.of(context).primary,
                textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                      fontFamily: 'Readex Pro',
                      color: Colors.white,
                    ),
                elevation: 3,
                borderSide: BorderSide(
                  color: Colors.transparent,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
                // child: Padding(
                //   padding: EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                //   child: FFButtonWidget(
                  //   onPressed: () async {
                  //  if (_model.textController1.text.isNotEmpty && _model.textController2.text.isNotEmpty){
                  //    showDialog(context: context, builder: (context){
                  //     return Container(
                  //       height: 200,
                  //       width: 200,
                  //       child: AlertDialog(
                  //         content: Text('Data saved'),
                  //         actions: [
                  //           TextButton(onPressed: (){
                  //             context.pop();
                            
                  //           }, child: Text('Cancel')),
                  //               TextButton(onPressed: (){
                  //                 updateProfilEmail(_model.textController2.text);
                  //                 updateProfileName(_model.textController1.text);
                                
                  //             context.pop();
                  //             context.safePop();
                  //           }, child: Text('Save')),
                  //         ],
                  //         ),
                          
                  //     );
                  //   });
                  //  } else {
                  //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Fill both fields!')));
                  //  }
                //     },
                //     text: 'Save ',
                //     options: FFButtonOptions(
                //       width: 150,
                //       height: 44,
                //       padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                //       iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                //       color: FlutterFlowTheme.of(context).primaryBackground,
                //       textStyle: FlutterFlowTheme.of(context).bodyMedium,
                //       elevation: 0,
                //       borderSide: BorderSide(
                //         color: FlutterFlowTheme.of(context).accent1,
                //         width: 2,
                //       ),
                //       borderRadius: BorderRadius.circular(38),
                //     ),
                //   ).animateOnPageLoad(
                //       animationsMap['buttonOnPageLoadAnimation']!),
                // ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
