import 'package:cipherx/features/splash_screen.dart';
import 'package:cipherx/firebase/messaging/gsm.dart';
import 'package:cipherx/firebase/messaging/msg.dart';
import 'package:cipherx/firebase/notifications/messaging.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/data/latest.dart';
import 'package:timezone/timezone.dart';

Future _firebaseBackgroundMessage(RemoteMessage message) async {
  if (message.notification != null) {
    print('some notification print');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
    apiKey: 'AIzaSyC7tz5NIMIbbl8rcPJHlG-8cMwUH2n9RG4',
    appId: '1:928183094879:android:1f316ad50147c88ccad5ea',
    messagingSenderId: '928183094879',
    projectId: 'cipherx-a2088',
    storageBucket: 'storageBucket',
  ));
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: true,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User granted permission');
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    print('User granted provisional permission');
  } else {
    print('User declined or has not accepted permission');
  }
  initializeTimeZones();
  setLocalLocation(
      getLocation('America/Detroit')); // Set your local time zone here
  // PushNotifications.init();
  // FirebaseMessaging.onBackgroundMessage((_firebaseBackgroundMessage));
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CipherX',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SplashScreen(),
      // Scaffold(
      //   appBar: AppBar(title: const Text('Task Manager')),
      //   body: Column(
      //     children: [
      //       Expanded(child: TaskNotifier()), // Display the tasks
      //       AddTaskButton(), // Button to add a new task
      //     ],
      //   ),
      // ),
    );
  }
}

class AddTaskButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTaskScreen()),
          );
        },
        child: Text('Add Task'),
      ),
    );
  }
}
