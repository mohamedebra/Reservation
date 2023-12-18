import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reservation/cubit/state.dart';
import 'package:sqflite/sqflite.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
class GymCubit extends Cubit<GymState> {
  GymCubit() : super(GymIntialstate());
  static GymCubit get(context) => BlocProvider.of(context);
  File proFileimage = File('/data/user/0/com.example.gem/cache/89ff5f8e-476d-4727-9d55-4eab7403648f5418499620502375441.jpg');
  var picker = ImagePicker();
  Uint8List? bytes;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  notificationDetails() {
    return const NotificationDetails(
        android: AndroidNotificationDetails('channelId', 'channelName',
            importance: Importance.max),
        iOS: DarwinNotificationDetails());
  }

  Future<void> showNotifications(String title,String body) async {

    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
    );
  }

  showNotification(String title , String _time,data) {

    if (title.isEmpty || _time.isEmpty) {
      return ;
    }

    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    flutterLocalNotificationsPlugin.show(
        10, title, _time, notificationDetails);

    tz.initializeTimeZones();
    final tz.TZDateTime scheduledAt = tz.TZDateTime.from(data, tz.local);

    flutterLocalNotificationsPlugin.zonedSchedule(
        10, 'Reservation', 'لقد تم انتهاء اشتراك  $title', scheduledAt, notificationDetails,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true,
        payload: 'Ths s the data');
  }


  // Get image
  Future getImage() async{
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if(pickedFile != null)
    {
      proFileimage = File(pickedFile.path);
      emit(ChangeIamge());
      bytes = proFileimage.readAsBytesSync();
      emit(GetImageSucsecc());
      print(pickedFile.path);
    }else
    {
      print('No image selected');

    }
  }

}
