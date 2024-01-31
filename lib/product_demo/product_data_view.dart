import 'dart:convert';
import 'dart:developer';

import 'package:api_project_server/product_demo/Detailpage.dart';
import 'package:api_project_server/product_demo/product.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main()
{
    runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        "detail" : (context) => Detailpage(),
        "first" : (context) => Myapp(),
      },
      initialRoute: "first",
      // home: Myapp(),
    ));
}
class Myapp extends StatefulWidget {
  const Myapp({super.key});

  @override
  State<Myapp> createState() => _MyappState();
}

class _MyappState extends State<Myapp> {

  String str = "";
  bool search = false;
  Map m = {};

  Future getdata(String str)
  async {
    Uri url = Uri();
    // var url = Uri.parse('https://dummyjson.com/products');

      if(str == "")
      {
          url = Uri.https('dummyjson.com','products');
      }
      else
      {
        // url = Uri.https('dummyjson.com','products/search?q=$str');
          url = Uri.parse('https://dummyjson.com/products/search?q=$str');
      }

    var response = await http.get(url);
    m = jsonDecode(response.body);
;{
  // log("${m}");  //developer library
    }
    return m;
  }

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   // getHttp();
  //   getdata();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: search?AppBar(
        backgroundColor: Colors.grey,
        title: TextFormField(
          decoration: InputDecoration(hintText: "Search"),
          onChanged: (value) {
            // getdata(value);
            setState(() {
              str = value;
            });
          },
        ),
        actions: [
          IconButton(onPressed: (){
            setState(() {
              str = "";
              getdata(str);
              search=!search;
            });
          }, icon: Icon(Icons.cancel))
        ],
      ):AppBar(
        title: Text("PRODUCT DETAILS",style: TextStyle(color: Colors.black38)),
        backgroundColor: Colors.grey,
        actions: [
          IconButton(onPressed: (){
            setState(() {
              search=!search;
            });
          }, icon: Icon(Icons.search))
        ],
      ),
      body: FutureBuilder(
        future: getdata("${str}"),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting)
          {
              return Center(child: CircularProgressIndicator(),);
          }
          else
          {
            if(snapshot.hasData)
            {
              Map m = snapshot.data;
              List l = m['products'];
              print(l);
              log("l : ${l}");
              return ListView.builder(
                itemCount: l.length,
                itemBuilder: (context, index) {

                  print("${jsonEncode(l[index])}"); //Map
                  product s = product.fromJson(l[index]);
                  print("s = ${s}");

                  return Card(
                    child: ListTile(
                      onTap: () {
                        Navigator.pushNamed(context, "detail" ,arguments: s);
                      },
                      title: Text("${s.title}"),
                      subtitle: Text("${s.description}",maxLines: 1,),
                      trailing: Text("${s.price} ₹"),
                      leading: CircleAvatar(backgroundImage: NetworkImage("${s.thumbnail}")),
                    ),
                  );

                },
              );

            }
            else
            {
              return Center(child: CircularProgressIndicator(),);
            }
          }
        },),
    );
  }
}
