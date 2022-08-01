import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

import '../services/firestore_services.dart';
import '../services/signaling.dart';

class CallReceivePage extends StatefulWidget {
  const CallReceivePage({Key? key}) : super(key: key);

  @override
  State<CallReceivePage> createState() => _CallReceivePageState();
}

class _CallReceivePageState extends State<CallReceivePage> {
  Signaling signaling = Signaling();
  RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  String? roomId;
  bool callingNow = false;

  @override
  void initState() {
    _localRenderer.initialize();
    _remoteRenderer.initialize();

    signaling.onAddRemoteStream = ((stream) {
      _remoteRenderer.srcObject = stream;
      setState(() {});
    });

    super.initState();
  }

  @override
  void dispose() {
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Call And Receive Page"),
        ),
        body: StreamBuilder(
            stream: FirestoreServices().checkLatestRoom(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  var data = snapshot.data.docs.last;
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(),
                        ElevatedButton(
                          onPressed: () {
                            signaling.openUserMedia(
                                _localRenderer, _remoteRenderer);
                            setState(() {});
                          },
                          child: Text("Open camera & microphone"),
                        ),
                        callingNow
                            ? ElevatedButton(
                                onPressed: () {}, child: Text("Calling..."))
                            : data["isAnswered"]
                                ? ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        callingNow = true;
                                      });
                                      signaling.createRoom(_remoteRenderer);
                                    },
                                    child: Text("Call Now"))
                                : ElevatedButton(
                                    onPressed: () {
                                      signaling.joinRoom(
                                        data.id,
                                        _remoteRenderer,
                                      );
                                    },
                                    child: Text("Accept Call")),
                        SizedBox(
                          width: 8,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            signaling.hangUp(_localRenderer);
                            setState(() {
                              callingNow = false;
                            });
                          },
                          child: Text("Hangup"),
                        ),
                        SizedBox(height: 8),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                    child: RTCVideoView(_localRenderer,
                                        mirror: true)),
                                Expanded(child: RTCVideoView(_remoteRenderer)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }));
  }
}
