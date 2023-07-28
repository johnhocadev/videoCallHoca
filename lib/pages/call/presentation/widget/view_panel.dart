import 'package:flutter/material.dart';
import 'package:video_call_app/pages/call/view_model/calling_vm.dart';

class ViewPanel extends StatelessWidget {
  const ViewPanel({
    super.key,
    required this.provider,
  });

  final CallingPageProvider provider;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: provider.isViewPanelVisible,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 48),
        alignment: Alignment.bottomCenter,
        child: FractionallySizedBox(
          heightFactor: 0.5,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 48),
            child: ListView.builder(
              reverse: true,
              itemCount: provider.infoString.length,
              itemBuilder: (context, index) {
                if (provider.infoString.isEmpty) {
                  return Text(
                    'NO Data',
                    style: TextStyle(color: Colors.white),
                  );
                }
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            provider.infoString[index],
                            style: TextStyle(color: Colors.blueGrey),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
