import 'dart:convert';

import 'package:api_project_server/add_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main()
{
    runApp(MaterialApp(
      home: view_data(),
      debugShowCheckedModeBanner: false,
    ));
}
class view_data extends StatefulWidget {
  const view_data({super.key});

  @override
  State<view_data> createState() => _view_dataState();
}

class _view_dataState extends State<view_data> {

  List l=[];
  Map m={};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future get_data()
  async {
    var url = Uri.parse('https://projectofflutter.000webhostapp.com/view_api.php');
    var response = await http.get(url);
    m = jsonDecode(response.body);
    l = m['res'];
    print(l);
    return l;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.teal.shade800,
        title: Text("DETAILS",style: TextStyle(color: Colors.white)),
      ),
      body: FutureBuilder(
          future: get_data(),
          builder: (context, snapshot) {
            if(snapshot.connectionState==ConnectionState.done)
            {
                // l=snapshot.data;
                return ListView.builder(
                  itemCount: l.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: (l[index]['image']!="")?CircleAvatar(backgroundImage: NetworkImage("https://projectofflutter.000webhostapp.com/${l[index]['image']}")):null,
                      title: Text("${l[index]['name']}"),
                      subtitle: Text("${l[index]['contact']}"),
                      trailing: Wrap(children: [
                        IconButton(onPressed: (){
                          showDialog(context: context, builder: (context) {
                            return AlertDialog(
                              title: Text("Are you sure delete this data ...."),
                              actions: [
                                  TextButton(onPressed: (){
                                    Navigator.pop(context);
                                  }, child: Text("NO")),
                                  TextButton(onPressed: () async {
                                    var url = Uri.parse('https://projectofflutter.000webhostapp.com/delete_api.php?id=${l[index]['id']}');
                                    var response = await http.get(url);
                                    print(response.body);
                                    Navigator.pop(context);
                                    setState(() { });
                                  }, child: Text("YES")),
                              ],
                            );
                          },);
                        }, icon: Icon(Icons.delete)),
                        IconButton(onPressed: (){
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                              return data_add(l[index]);
                            },));
                        }, icon: Icon(Icons.edit)),
                      ]),
                    );
                  },
                );
            }
            else
            {
                return Center(child: CircularProgressIndicator(),);
            }
          },
      ),
    );
  }
}
