import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reservation/cubit/cubit.dart';
import 'package:reservation/cubit/state.dart';
import 'package:reservation/data/sql.dart';


class ProDuctInfo extends StatefulWidget {
  const ProDuctInfo({Key? key, this.datenow, this.nextdate, this.title, this.image, this.pid}) : super(key: key);
  static String id = 'ProductInfo';
  final datenow;
  final nextdate;
  final title;
  final image;
  final pid;
  @override
  State<ProDuctInfo> createState() => _ProDuctInfoState();
}

class _ProDuctInfoState extends State<ProDuctInfo> {
  var scffoldKey = GlobalKey<ScaffoldState>();
  List notes = [];
  Sqldb sqldb = Sqldb();
  String? nextdate;
  String? title;
  String? datenow;
  String? image;
  Future readDate() async {
    List<Map> response = await sqldb.read("notes");
    notes.addAll(response);
    if (mounted) {
      setState(() {});
    }
    return response;
  }
  @override
  void initState() {
    readDate();
    nextdate = widget.nextdate;
    title = widget.title;
    datenow = widget.datenow;
    image = widget.image;

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    // var product = ModalRoute.of(context)?.settings.arguments as Product?;

    return BlocProvider(
      create: (context) => GymCubit(),
      child: BlocConsumer<GymCubit, GymState>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = GymCubit.get(context);
          return Scaffold(
            key: scffoldKey,
            body:SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: MediaQuery
                        .of(context)
                        .size
                        .height * .7,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    child: Image.file(File(image!),fit: BoxFit.fill,),),
                  Opacity(
                    opacity: .3,
                    child: Container(
                      color: Colors.white,
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      height: MediaQuery
                          .of(context)
                          .size
                          .height * .3,

                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(title!, style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              color: Colors.black
                            ),),
                            SizedBox(height: 10,),
                            Text(nextdate!, style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black

                            ),),
                            SizedBox(height: 10,),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );

  }
}
