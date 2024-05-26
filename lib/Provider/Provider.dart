import 'dart:convert';
import 'package:deimoxapp/Model/Model.dart';
import 'package:deimoxapp/screens/clock/alarma.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;

class alarmprovider extends ChangeNotifier {
  late SharedPreferences preferences;
  List<Model> modelist = [];
  List<String> listofstring = [];
  FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;
  late BuildContext context;

  SetAlaram(String label, String dateTime, bool check, String repeat, int id, int milliseconds) {
    modelist.add(Model(label: label, dateTime: dateTime, check: check, when: repeat, id: id, milliseconds: milliseconds));
    notifyListeners();
  }

  EditSwitch(int index, bool check) {
    modelist[index].check = check;
    notifyListeners();
  }

  GetData() async {
    preferences = await SharedPreferences.getInstance();
    List<String>? cominglist = await preferences.getStringList("data");
    if (cominglist != null) {
      modelist = cominglist.map((e) => Model.fromJson(json.decode(e))).toList();
      notifyListeners();
    }
  }

  SetData() {
    listofstring = modelist.map((e) => json.encode(e.toJson())).toList();
    preferences.setStringList("data", listofstring);
    notifyListeners();
  }

  Initialize(BuildContext con) async {
    context = con;
    const androidInitSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iOSInitSettings = DarwinInitializationSettings();
    const initSettings = InitializationSettings(android: androidInitSettings, iOS: iOSInitSettings);
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin!.initialize(initSettings, onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);

    // Define el canal de notificaciones con sonido personalizado
    const androidChannel = AndroidNotificationChannel(
      'your_channel_id', // id del canal
      'your_channel_name', // nombre del canal
      description: 'your_channel_description', // descripción del canal
      importance: Importance.max,
      sound: RawResourceAndroidNotificationSound('alarmaxd'),
      playSound: true,
    );

    final androidPlugin = flutterLocalNotificationsPlugin!.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin != null) {
      await androidPlugin.createNotificationChannel(androidChannel);
    }
  }

  void onDidReceiveNotificationResponse(NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;
    if (payload != null) {
      debugPrint('notification payload: $payload');
    }
    await Navigator.push(context, MaterialPageRoute<void>(builder: (context) => MyApp()));
  }

  ShowNotification() async {
    const androidNotificationDetails = AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      channelDescription: 'your_channel_description',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      sound: RawResourceAndroidNotificationSound('alarmaxd'),
    );
    const notificationDetails = NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin!.show(0, 'plain title', 'plain body', notificationDetails, payload: 'item x');
  }

  ScheduleNotification(DateTime dateTime, int randomNumber) async {
  int newTime = dateTime.millisecondsSinceEpoch - DateTime.now().millisecondsSinceEpoch;
  await flutterLocalNotificationsPlugin!.zonedSchedule(
    randomNumber,
    'Alarm Clock',
    "${DateFormat().format(DateTime.now())}",
    tz.TZDateTime.now(tz.local).add(Duration(milliseconds: newTime)),
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'your_channel_id',
        'your_channel_name',
        channelDescription: 'your_channel_description',
        sound: RawResourceAndroidNotificationSound('alarmaxd'), // me mate
        autoCancel: false,
        playSound: true,
        importance: Importance.max, // puse importante
      ),
    ),
    androidAllowWhileIdle: true, // Cambiado de 'androidScheduleMode' a 'androidAllowWhileIdle' porque no servia
    uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
  );
}


  CancelNotification(int notificationId) async {
    await flutterLocalNotificationsPlugin!.cancel(notificationId);
  }
}
