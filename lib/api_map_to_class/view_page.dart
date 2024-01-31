
import 'dart:convert';
import 'dart:developer';

import 'package:api_project_server/api_map_to_class/student.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main()
{
  runApp(MaterialApp(
    home: first_page(),
  ));
}
class first_page extends StatefulWidget {
  const first_page({super.key});

  @override
  State<first_page> createState() => _first_pageState();
}

class _first_pageState extends State<first_page> {

  final dio = Dio();

  //dio example
  // void getHttp() async {
  //   final response = await dio.get('https://projectofflutter.000webhostapp.com/view_api.php');
  //   Map m = response.data;
  //   log("${m}");
  // }

  Future getdata()
  async {
    var url = Uri.parse('https://projectofflutter.000webhostapp.com/view_api.php');
    // var url = Uri.https('domain name','last name');
    var response = await http.get(url);
    Map m = jsonDecode(response.body);
    log("${m}");
    return m;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getHttp();
    getdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MAP TO CLASS CONVERT DATA"),
      ),
      body: FutureBuilder(
        future: getdata(),
        builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.done)
            {
                if(snapshot.hasData)
                {
                  Map m = snapshot.data;
                  List l = m['res'];
                  return ListView.builder(
                    itemCount: l.length,
                    itemBuilder: (context, index) {

                      print("${jsonEncode(l[index])}"); //Map
                      student s = student.fromMap(l[index]);
                      print("s = ${s}");
                      return ListTile(
                        title: Text("${s.name}"),
                        subtitle: Text("${s.contact}"),
                        leading: CircleAvatar(backgroundImage: NetworkImage("${s.image}")),
                      );

                    },
                  );

                }
                else
                {
                  return Center(child: CircularProgressIndicator(),);
                }
            }
            else
            {
                return Center(child: CircularProgressIndicator(),);
            }
      },),
    );
  }
}
