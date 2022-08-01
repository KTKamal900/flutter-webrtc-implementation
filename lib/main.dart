import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'pages/call_receive_page.dart';
import 'pages/rooms_page.dart';
import 'services/firestore_services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("WebRTC Demo"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CallReceivePage()));
              },
              child: Text("Call / Receive"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => RoomsPage()));
              },
              child: Text("Join / Create Rooms"),
            ),
            SizedBox(height: 20),
            SizedBox(height: 20),
            ElevatedButton(
                onPressed: () async {
                  await FirestoreServices().refreshTheRoom();
                  debugPrint("Refresh Done");
                  // showModalBottomSheet(
                  //     context: context,
                  //     builder: (context) {
                  //       return SnackBar(content: Text("Refresh Done"));
                  //     });
                },
                child: Text("Refresh")),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                  "Note - If you face any issue please click the refresh button"),
            ),
          ],
        ),
      ),
    );
  }
}
