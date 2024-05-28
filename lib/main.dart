import 'dart:async';

import 'package:ffi/ffi.dart';
import 'package:flutter/material.dart';
import 'package:testcpplinux/shared/services/ffi/ffi.service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final keyboardEvent = await KeyboardEvent.load();
  runApp(MyApp(keyboardEvent));
}

class MyApp extends StatefulWidget {
  final KeyboardEvent keyboardEvent;
  MyApp(this.keyboardEvent);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool keyboardStatus = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    widget.keyboardEvent.initKeyboardEvent('/dev/input/event4'.toNativeUtf8());

    // Set the interval for the keyboard event status check
    widget.keyboardEvent.setEventCheckInterval(4);

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      // widget.keyboardEvent.checkAndResetKeyboardEventStatus();
      setState(() {
        keyboardStatus = widget.keyboardEvent.getKeyboardEventStatus() == 1;
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    widget.keyboardEvent.stopKeyboardEvent();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Keyboard Event Status'),
        ),
        body: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Keyboard event status:"),
              Icon(
                Icons.circle,
                color: keyboardStatus ? Colors.greenAccent : Colors.redAccent,
              )
            ],
          ),
        ),
      ),
    );
  }
}
