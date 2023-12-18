import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:reservation/data/sql.dart';
import 'package:reservation/screen/home.dart';


class EditNotes extends StatefulWidget {
  final datenow;
  final nextdate;
  final title;
  final image;
  final id;
  const EditNotes({Key? key, this.datenow, this.title,this.nextdate, this.id,this.image}) : super(key: key);

  @override
  State<EditNotes> createState() => _EditNotesState();
}


class _EditNotesState extends State<EditNotes> {
  GlobalKey<FormState> formState = GlobalKey();
  TextEditingController nextdate = TextEditingController();
  TextEditingController title = TextEditingController();
  TextEditingController datenow = TextEditingController();
  DateTime data = DateTime.now();
  File? proFileimage;
  var picker = ImagePicker();
  Uint8List? bytes;

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

  @override
  void initState() {
    nextdate.text = widget.nextdate;
    title.text = widget.title;
    datenow.text = widget.datenow;

    super.initState();
  }
  Sqldb db = Sqldb();
  @override
  Widget build(BuildContext context) {
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
                          hintText: 'Add Title',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          )
                      ),

                    ),
                    const SizedBox(height: 10,),
                    TextFormField(
                      controller: datenow,
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
                          datenow.text = DateFormat('yyyy-MM-dd').format(dataTime!);
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
                      controller: nextdate,
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
                          nextdate.text = DateFormat('yyyy-MM-dd').format(dataTime!);
                        });
                      },
                      onChanged: (value) {},
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "Time don't must in Empty";
                        }
                      },
                    ),
                    MaterialButton(onPressed: (){
                      getImage();
                    },
                      child: const Icon(Icons.camera),
                      color: Colors.grey,),
                    MaterialButton(
                      color: Colors.grey,
                      textColor: Colors.white,
                      onPressed: ()async{
                        int response = await db.update(
                            table: 'notes', title: title.text, dateNow: datenow.text, nextDate: nextdate.text,imageBytes:proFileimage!.path,
                        where:"id = ${widget.id}",

                        );
                        if(response > 0){
                          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Home()), (route) => false);
                        }
                        print(response);
                        print("response ================");
                      },child: Text('Edit Note'),)
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
