import 'package:deimoxapp/Provider/Provider.dart';
import 'package:deimoxapp/screens/clock_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'dart:math';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => alarmprovider()),
      ],
      child: const AlarmApp(),
    ),
  );
}

class AlarmApp extends StatefulWidget {
  const AlarmApp({super.key});

  @override
  _AlarmAppState createState() => _AlarmAppState();
}

class _AlarmAppState extends State<AlarmApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<alarmprovider>().Initialize(context);
    });
    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {});
    });
    context.read<alarmprovider>().GetData();
  }

  @override
  Widget build(BuildContext context) {
    return const MyApp();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF1C1C1C),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 16, 14, 19),
          elevation: 0,
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color.fromARGB(255, 33, 33, 33),
          secondary: Colors.white,
        ),
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.access_time, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ClockScreen()),
              );
            },
          ),
        ],
        title: const Text(
          'Programar Alarma',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 31, 36, 69),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            height: MediaQuery.of(context).size.height * 0.1,
            child: Center(
              child: Text(
                DateFormat.yMEd().add_jms().format(DateTime.now()),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Consumer<alarmprovider>(builder: (context, alarm, child) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.7,
              child: ListView.builder(
                itemCount: alarm.modelist.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: MediaQuery.of(context).size.width * 0.16,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.grey[900],
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        DateTime? newDateTime =
                                            await showDateTimePicker(
                                                context,
                                                alarm.modelist[index]
                                                    .milliseconds!);
                                        if (newDateTime != null) {
                                          String formattedDateTime =
                                              DateFormat()
                                                  .add_jms()
                                                  .format(newDateTime);
                                          int milliseconds = newDateTime
                                              .millisecondsSinceEpoch;
                                          context
                                              .read<alarmprovider>()
                                              .EditAlarm(
                                                  index,
                                                  formattedDateTime,
                                                  milliseconds);
                                          context
                                              .read<alarmprovider>()
                                              .SetData();
                                        }
                                      },
                                      child: Text(
                                        alarm.modelist[index].dateTime!,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text(
                                        "|${alarm.modelist[index].label}",
                                        style: const TextStyle(
                                          color: Colors.white70,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    CupertinoSwitch(
                                      activeColor: Colors.red,
                                      value: alarm.modelist[index].check,
                                      onChanged: (value) {
                                        if (value == true) {
                                          DateTime datetime = DateTime
                                              .fromMillisecondsSinceEpoch(alarm
                                                  .modelist[index]
                                                  .milliseconds!);
                                          int randomNumber =
                                              alarm.modelist[index].id!;
                                          context
                                              .read<alarmprovider>()
                                              .ScheduleNotification(
                                                  datetime, randomNumber);
                                          context
                                              .read<alarmprovider>()
                                              .EditSwitch(index, value);
                                          context
                                              .read<alarmprovider>()
                                              .SetData();
                                        } else {
                                          context
                                              .read<alarmprovider>()
                                              .CancelNotification(
                                                  alarm.modelist[index].id!);
                                          context
                                              .read<alarmprovider>()
                                              .EditSwitch(index, value);
                                          context
                                              .read<alarmprovider>()
                                              .SetData();
                                        }
                                      },
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        context
                                            .read<alarmprovider>()
                                            .DeleteAlarm(index);
                                      },
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddAlarm()),
          );
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  Future<DateTime?> showDateTimePicker(
      BuildContext context, int milliseconds) async {
    DateTime initialDate = DateTime.fromMillisecondsSinceEpoch(milliseconds);
    TimeOfDay initialTime =
        TimeOfDay(hour: initialDate.hour, minute: initialDate.minute);

    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: initialTime,
      );

      if (selectedTime != null) {
        return DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedTime.hour,
          selectedTime.minute,
        );
      }
    }
    return null;
  }
}

class AddAlarm extends StatelessWidget {
  const AddAlarm({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController labelcontroller = TextEditingController();
    TextEditingController whencontroller = TextEditingController();
    int? randomNumber;
    String? formattedDateTime;

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(
              Icons.menu,
              color: Colors.white,
            ),
          )
        ],
        title: const Text(
          'Agregar Alarma',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextField(
              controller: labelcontroller,
              decoration: InputDecoration(
                labelText: "Nombre de Alarma",
                labelStyle: TextStyle(
                  color: Colors.white,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
            ),
            TextField(
              controller: whencontroller,
              decoration: InputDecoration(
                labelText: "Repetir",
                labelStyle: TextStyle(
                  color: Colors.white,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                DateTime? selectedDateTime = await showDateTimePicker(context);
                if (selectedDateTime != null) {
                  formattedDateTime =
                      DateFormat().add_jms().format(selectedDateTime);
                  int milliseconds = selectedDateTime.millisecondsSinceEpoch;
                  randomNumber = UniqueKey().hashCode;

                  context.read<alarmprovider>().SetAlaram(
                        labelcontroller.text,
                        formattedDateTime!,
                        false,
                        whencontroller.text,
                        randomNumber!,
                        milliseconds,
                      );
                  context.read<alarmprovider>().SetData();

                  Navigator.pop(context);
                }
              },
              child: const Text("Añadir Alarma"),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                textStyle: const TextStyle(fontSize: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<DateTime?> showDateTimePicker(BuildContext context) async {
    DateTime initialDate = DateTime.now();
    TimeOfDay initialTime = TimeOfDay.now();

    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: initialTime,
      );

      if (selectedTime != null) {
        return DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedTime.hour,
          selectedTime.minute,
        );
      }
    }
    return null;
  }
}
