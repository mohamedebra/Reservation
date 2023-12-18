import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:reservation/cubit/cubit.dart';
import 'package:reservation/cubit/state.dart';
import 'package:reservation/data/sql.dart';
import 'package:reservation/screen/home.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class AddNotes extends StatefulWidget {
  const AddNotes({super.key});
  static TextEditingController nextDate = TextEditingController();

  @override
  State<AddNotes> createState() => _AddNotesState();
}

class _AddNotesState extends State<AddNotes> {
  GlobalKey<FormState> formState = GlobalKey();
  TextEditingController time = TextEditingController();
  TextEditingController _time = TextEditingController();
  TextEditingController title = TextEditingController();

  DateTime data = DateTime.now();

  Sqldb db = Sqldb();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GymCubit,GymState>(
      listener: (context,state){},
      builder: (context,state){
        var cubit = GymCubit.get(context);
        return Scaffold(
          appBar: AppBar(),
          body: Container(
            padding: EdgeInsets.all(20),
            child: ListView(
              children: [
                Form(
                    key: formState,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: title,
                          decoration: InputDecoration(
                              hintText: 'Add title',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)
                              )
                          ),
                        ),
                        const SizedBox(height: 10,),
                        TextFormField(
                          controller: time,
                          keyboardType: TextInputType.datetime,
                          decoration: InputDecoration(
                              hintText: 'Date now',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)
                              )
                          ),
                          onTap: () async {
                            DateTime? dataTime= await  showDatePicker(
                                context: context, initialDate: data, firstDate: DateTime(2000), lastDate: DateTime(2090));
                            setState(() {
                              time.text = DateFormat('yyyy-MM-dd').format(dataTime!);
                            });
                          },
                          onChanged: (value) {},
                          validator: (val) {
                            if (val!.isEmpty) {
                              return "Time don't must in Empty";
                            }
                          },
                        ),
                        const SizedBox(height: 10,),
                        TextFormField(
                          controller: AddNotes.nextDate,
                          keyboardType: TextInputType.datetime,
                          decoration: InputDecoration(
                              hintText: 'Next Date',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)
                              )
                          ),
                          onTap: () async {
                            DateTime? dataTime= await  showDatePicker(
                                context: context, initialDate: data, firstDate: DateTime(2000), lastDate: DateTime(2090));
                            setState(() {
                              AddNotes.nextDate.text = DateFormat('yyyy-MM-dd').format(dataTime!);
                            });
                          },
                          onChanged: (value) {},
                          validator: (val) {
                            if (val!.isEmpty) {
                              return "Time don't must in Empty";
                            }
                          },
                        ),
                        const SizedBox(height: 10,),
                        TextField(
                          controller: _time,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              suffixIcon: InkWell(
                                child: const Icon(
                                  Icons.timer_outlined,
                                ),
                                onTap: () async {
                                  final TimeOfDay? slectedTime = await showTimePicker(
                                      context: context, initialTime: TimeOfDay.now());

                                  if (slectedTime == null) {
                                    return;
                                  }

                                  _time.text =
                                  "${slectedTime.hour}:${slectedTime.minute}:${slectedTime.period.toString()}";

                                  DateTime newDT = DateTime(
                                    data.year,
                                    data.month,
                                    data.day,
                                    slectedTime.hour,
                                    slectedTime.minute,
                                  );
                                  setState(() {
                                    data   = newDT;
                                  });
                                },
                              ),
                              label: Text("Time")),
                        ),
                        const SizedBox(height: 10,),

                        MaterialButton(
                          color: Colors.grey,
                          textColor: Colors.white,
                          onPressed: ()async{
                            int? response = await db.insertNoteWithImage(
                                title: title.text,
                                dateNow: time.text,
                                nextDate: AddNotes.nextDate.text,
                                imageBytes: cubit.proFileimage.path);
                            if(response! > 0){
                              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Home()), (route) => false);
                            }
                            cubit.showNotification(title.text,_time.text,data);
                            print(response);
                            print("response ================");
                          },child: Text('Add Note'),),
                        MaterialButton(onPressed: (){
                          cubit.getImage();
                        },
                          child: const Icon(Icons.camera),
                          color: Colors.grey,),


                      ],
                    ))
              ],
            ),
          ),
        );
      },
    );
  }
}