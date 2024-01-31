import 'dart:convert';
import 'dart:developer';

import 'package:api_project_server/product_demo/product.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/carousel/gf_carousel.dart';
import 'package:getwidget/components/carousel/gf_items_carousel.dart';
import 'package:getwidget/components/rating/gf_rating.dart';
import 'package:http/http.dart' as http;

class Detailpage extends StatefulWidget {
  const Detailpage({super.key});

  @override
  State<Detailpage> createState() => _DetailpageState();
}

class _DetailpageState extends State<Detailpage> {

  @override
  Widget build(BuildContext context) {

    int val_index = 0;
    //navigator.pushnamed in return s(class datatype) for product datatype of p
    product p = ModalRoute.of(context)!.settings.arguments as product;

    Future getdata()
    async {
      var url = Uri.parse('https://dummyjson.com/products/${p.id}');
      // var url = Uri.https('domain name','last name');
      var response = await http.get(url);
      Map m = jsonDecode(response.body);
      log("${m}");  //developer library
      return m;
    }

    return Scaffold(
      appBar: AppBar(
        // title: Text("PRODUCT DETAILS"),
        title: Text("${p.title}"),
        backgroundColor: Colors.grey,
        // leading: CircleAvatar(backgroundImage: NetworkImage("${p.thumbnail}")),
      ),
      body: FutureBuilder(
        future: getdata(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.done)
          {
            if(snapshot.hasData)
            {
              Map m = snapshot.data;
              product p = product.fromJson(m);
              List l = m['images'];
              log("${l}");
              // List l = m['res'];
              // return ListTile(
              //   title: Text("${p.title}"),
              //   subtitle: Text("${p.description}"),
              //   trailing: Text("${p.price}"),
              //   leading: CircleAvatar(backgroundImage: NetworkImage("${p.thumbnail}")),
              // );
              return Column(children: [
                SizedBox(height: 10,),
                Center(child: Text("${p.title}",style: TextStyle(fontSize: 35,fontWeight: FontWeight.bold,),),),
                SizedBox(height: 10,),
                Center(child: Container(
                  height: 200,width: 300,
                  decoration: BoxDecoration(
                    boxShadow: [BoxShadow(color: Colors.black,spreadRadius: 0.5,blurRadius: 8,)],
                    shape: BoxShape.circle,
                    image: DecorationImage(fit: BoxFit.fill,image: NetworkImage("${p.thumbnail}")),
                  ),
                  // child: Image.network(fit: BoxFit.fill,"${p.thumbnail}"),
                ),),
                SizedBox(height: 10,),
                GFCarousel(
                  height: 350,
                  items: l.map(
                        (url) {
                      return Container(
                        decoration: BoxDecoration(
                            boxShadow: [BoxShadow(color: Colors.black,spreadRadius: 0.5,blurRadius: 8,)],
                            shape: BoxShape.rectangle,
                          // borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.black,width: 2)
                        ),
                        margin: EdgeInsets.all(10.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          child: Image.network(
                              url,
                              fit: BoxFit.fill,
                              width: 1000.0
                          ),
                        ),
                      );
                    },
                  ).toList(),

                  // onPageChanged: (index) {
                  //   val_index = index;
                  //   setState(() {});
                  //   // setState(() {
                  //   //   index;
                  //   // });
                  // },
                ),
                Center(child: Text("${p.description}",style: TextStyle(fontSize: 15)),),
                GFRating(
                 size: 50,
                  color: Colors.deepPurple.shade600,
                  value: p.rating,
                  onChanged: (value) {
                    setState(() {
                      p.rating = value;
                    });
                  },
                ),
                SizedBox(height: 10,),
                Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: [
                  Center(child: Text("Price : ${p.price} ₹",style: TextStyle(fontSize: 25)),),
                  Center(child: Text("Discount price : ${p.discountPercentage} %",style: TextStyle(fontSize: 16)),),
                ],),
                SizedBox(height: 5,),
                Center(child: Text("Brand : ${p.brand}",style: TextStyle(fontSize: 25)),),

              ],);
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
