import 'dart:io';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reservation/data/sql.dart';
import 'package:reservation/screen/productInfo.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController search = TextEditingController();
  List searchList = [];

  Sqldb sqldb = Sqldb();
  bool inLoading = true;
  List notes = [];

  Future readDate() async {
    List<Map> response = await sqldb.read("notes");
    notes.addAll(response);
    inLoading = false;
    if (mounted) {
      setState(() {});
    }
    return response;
  }

  void _performSearch(String searchTerm) async {
    final List<Map<String, dynamic>> searchResults =
        await Sqldb().searchNotes(searchTerm);
    // Update the UI with the search results
    setState(() {
      // Update the state or a variable to hold the search results
      // For example, you can use a List<Map<String, dynamic>> variable
      notes = searchResults;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          height: 50,
          child: TextFormField(
            controller: search,
            // onTap: (){
            //   Navigator.push(context, MaterialPageRoute(builder: (context) => Search()));
            // },
            onChanged: (val) {
              setState(() {
                _performSearch(val);
              });
            },
            decoration: InputDecoration(
                hintText: 'Search',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10))),
          ),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: notes.length,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return InkWell(
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
                            borderRadius: BorderRadius.circular(50)),
                        width: 70,
                        // height: 100,
                        child: Image.file(File(notes[index]['image'])),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      flex: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Name  : ${notes[index]['title']}",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 17),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            "Date now  : ${notes[index]['dateNow']}",
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Next Date : ${notes[index]['nextDate']}",
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
