import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:reservation/cubit/cubit.dart';
import 'package:reservation/screen/addNotes.dart';
import 'package:reservation/screen/home.dart';
import 'package:reservation/screen/productInfo.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('ic_launcher');

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
  );

  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => GymCubit(),
      child: MaterialApp(
        theme: ThemeData(

          primarySwatch: Colors.blueGrey,
        ),
        darkTheme: ThemeData.dark(),
        debugShowCheckedModeBanner: false,
        home: Home(),
        routes: {
          "AddNotes" : (context) =>  const AddNotes(),
          ProDuctInfo.id: (context) => ProDuctInfo(),

        },
      ),
    );
  }
}

