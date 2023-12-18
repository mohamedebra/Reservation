import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reservation/cubit/cubit.dart';
import 'package:reservation/cubit/state.dart';
import 'package:reservation/data/sql.dart';
import 'package:reservation/screen/productInfo.dart';
import 'package:reservation/screen/search.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tzz;


class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Sqldb sqldb = Sqldb();
  bool inLoading = true;
  List notes = [];
  File? proFileimage;
  var picker = ImagePicker();
  Uint8List? bytes;
  TextEditingController search = TextEditingController();
  int _tabBatIndex = 0;


  Future getImage() async{
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if(pickedFile != null)
    {
      setState(() {
        proFileimage = File(pickedFile.path);
        bytes = proFileimage!.readAsBytesSync();

      });

      print(pickedFile.path);
    }else
    {
      print('No image selected');

    }
  }

  Future readDate() async {
    List<Map> response = await sqldb.read("notes");
    notes.addAll(response);
    inLoading = false;
    if (mounted) {
      setState(() {});
    }
    return response;
  }
  // Future<void> scheduleNotification(DateTime time) async {
  //   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  //
  //   var now = DateTime.now();
  //   var scheduledTime = DateTime(now.year, now.month, now.day, time.hour, time.minute);
  //
  //   if (scheduledTime.isBefore(now)) {
  //     scheduledTime = scheduledTime.add(Duration(days: 1));
  //   }
  //
  //   const AndroidNotificationDetails androidPlatformChannelSpecifics =
  //   AndroidNotificationDetails(
  //     'your_channel_id',
  //     'your_channel_name',
  //     importance: Importance.high,
  //     priority: Priority.high,
  //   );
  //
  //   const NotificationDetails platformChannelSpecifics =
  //   NotificationDetails(android: androidPlatformChannelSpecifics);
  //
  //   await flutterLocalNotificationsPlugin.zonedSchedule(
  //     0,
  //     'Notification Title',
  //     'Notification Body',
  //     tzz.TZDateTime.from(scheduledTime, tzz.local), // Use tz.TZDateTime to set the time zone
  //     platformChannelSpecifics,
  //     androidAllowWhileIdle: true,
  //     uiLocalNotificationDateInterpretation:
  //     UILocalNotificationDateInterpretation.absoluteTime,
  //   );
  // }

  @override
  void initState() {
    setState(() {
      readDate();
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GymCubit,GymState>(
      listener: (context,state) {},
      builder: (context,state){
        return Scaffold(
          appBar: AppBar(
            title: Container(
              height: 50,
              child: TextFormField(
                controller: search,
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Search()));
                },
                onChanged: (val){
                  setState(() {
                  });
                },
                decoration: InputDecoration(
                    hintText: 'Search',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                    )
                ),

              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, "AddNotes");
            },
            child: Icon(Icons.add),
          ),
          body:                inLoading == true ? Center(
            child: CircularProgressIndicator(),
          ):ListView.builder(
            itemCount: notes.length,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Container(
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProDuctInfo(
                      title: notes [index]['title'],
                      datenow: notes [index]['dateNow'],
                      nextdate: notes [index]['nextDate'],
                      image: notes [index]['image'],
                      pid: notes [index]['id'],
                    )));          },
                  child: Padding(
                    padding: const EdgeInsets.all(7.0),
                    child: Card(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50)
                              ),
                              width: 70,
                              // height: 100,
                              child: Image.file(File(notes[index]['image'])) ?? const Image(image: AssetImage('images/12.jpg')),
                            ),
                          ),
                          const SizedBox(width: 5,),
                          Expanded(
                            flex: 5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Name  : ${notes[index]['title']}",

                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,

                                ),
                                Text("Date now  : ${notes[index]['dateNow']}",
                                  style:  TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold
                                  ),),
                                Text("Next Date : ${notes[index]['nextDate']}",
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold
                                  ),),

                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                IconButton(
                                  onPressed: () async {
                                    int response = await sqldb.delete("notes", "id = ${notes[index]["id"]}");
                                    if (response >= 0) {
                                      notes.removeWhere((element) =>
                                      element['id'] == notes[index]['id']);
                                      setState(() {});
                                    }
                                    setState(() {});

                                  },
                                  icon: Icon(Icons.delete),
                                  color: Colors.red,
                                ),
                                IconButton(
                                  onPressed: ()  {
                                    // Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditNotes(
                                    //   title: notes [index]['title'],
                                    //   datenow: notes [index]['dateNow'],
                                    //   nextdate: notes [index]['nextDate'],
                                    //   image: notes [index]['image'],
                                    //   id: notes [index]['id'],
                                    // )));
                                    print(notes [index]['image']);
                                  },
                                  icon: Icon(Icons.edit),
                                  color: Colors.blue,
                                ),
                              ],
                            ),
                          ),


                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

        );
      },
    );
  }
}

