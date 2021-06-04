import 'package:fastpnt/widgets/SearchBar.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';
import 'package:fastpnt/models/medcin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';

import '../main.dart';
import 'DetailPageMedcin.dart';
import 'login.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<String> data = [
    "Généraliste","Pédiatre","Dentiste","Ophtalmologue","Dermatologue","Cardiologue",
  ];

  Widget _buildItemList(BuildContext context, int index){
    if(index == data.length)
      return Center(
        child: CircularProgressIndicator(),
      );
    return GestureDetector(
      onTap: (){ setState(() {
        sp=data[index];
      });
      if(sp!=null){   print(data[index]);
        Navigator.push(context,MaterialPageRoute(builder: (context)=>PageSp(post: data[index])));
      }


      },
      child: Container(

        width: 150,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(

              width: 150,
              height: 180,
              decoration:BoxDecoration(

                  borderRadius: BorderRadius.all(Radius.circular(20)),
                gradient: new LinearGradient(
                    colors: [Colors.red, Colors.cyan],
                    begin: Alignment.centerRight,
                    end: Alignment.centerLeft)
                ) ,
              child: Center(

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('${data[index]}',style: TextStyle(fontSize: 20,color: Colors.black),),
                    ],
                  ),

              ),
            ),
          ],
        ),
      ),
    );
  }

  //CollectionReference medcin = FirebaseFirestore.instance.collection("Medcin");

 /*getData() async {
   var responsebody = await medcin.where("name",isEqualTo:'youba').get();
   responsebody.docs.forEach((element) {
     medcins.add(element.data());
        print(element.id);
   });
 //  responsebody.docs
 }*/
  String nm;
 @override
 /*void initState(){
   getData();
   super.initState();
 }*/

 @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: Colors.white,
      body:Container(
        child: Column(
          children:<Widget> [
            SizedBox(height: 20,),

           SearchBar(),

           Expanded(
             flex: 1,
             child: ScrollSnapList(

                    itemBuilder: _buildItemList,
                    itemSize: 150,
                    dynamicItemSize: true,

                    onReachEnd: (){

                    },
                    itemCount: data.length, onItemFocus: (int ) {

     },
                  ),
   ),

            Expanded(
              flex: 2,
              child: FutureBuilder(
                  future:medcin.where("valide", isEqualTo: true).get() ,
                  // ignore: missing_return
                  builder: (context , snapshot){
                 if( snapshot.hasData){
                   return ListView.builder(
                 itemCount: snapshot.data.docs.length,
                 itemBuilder: (context,i){
                   return ListTile(
                     title:Text( "${snapshot.data.docs[i].data()['name']}", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
                     leading: GestureDetector(
                       behavior: HitTestBehavior.translucent,
                       onTap: () {
                        // Navigator.push(context,MaterialPageRoute(builder: (context)=>DetailPage(post:snapshot.data.docs[i].data['name'])));

                       },
                       child: Container(
                         width:48,
                         height: 48,
                         padding: const EdgeInsets.symmetric(vertical: 4.0),
                         alignment: Alignment.center,
                         child:  CircleAvatar(
                              backgroundImage: NetworkImage('${snapshot.data.docs[i].data()['img']}'),
                         ),
                       ),

                     ),
                     subtitle: Text("${snapshot.data.docs[i].data()['specialite']}"),
                     trailing: Icon(Icons.keyboard_arrow_right),
                     onTap: () {
                       Navigator.push(context,MaterialPageRoute(builder: (context)=>DetailPage(doctor:snapshot.data.docs[i].data()['name'])));

                     },
                   );

                 }
                   );

                     }
                     if(snapshot.hasError)
                     {
                       return Text("error");
                     }
                     if(snapshot.connectionState==ConnectionState.waiting){
                       return Text("loading");
                     }

                  }

              ),
            ),
          ],
        ),
      )



    );
  }
}



class PageSp extends StatefulWidget {
  final String post;
  PageSp({this.post});
  @override
  _PageSpState createState() => _PageSpState();
}

class _PageSpState extends State<PageSp> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        child:  FutureBuilder(
            future:medcin.where("specialite", isEqualTo: widget.post.toString()).get() ,
            // ignore: missing_return
            builder: (context , snapshot){
              if( snapshot.hasData){
                return ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context,i){
                      return ListTile(
                        title:Text( "${snapshot.data.docs[i].data()['name']}", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
                        leading: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            // Navigator.push(context,MaterialPageRoute(builder: (context)=>DetailPage(post:snapshot.data.docs[i].data['name'])));

                          },
                          child: Container(
                            width:48,
                            height: 48,
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            alignment: Alignment.center,
                            child:  CircleAvatar(
                          backgroundImage: NetworkImage('${snapshot.data.docs[i].data()['img']}'),
                      ),
                          ),

                        ),
                        subtitle: Text("${snapshot.data.docs[i].data()['specialite']}"),
                        trailing: Icon(Icons.keyboard_arrow_right),
                        onTap: () {
                          Navigator.push(context,MaterialPageRoute(builder: (context)=>DetailPage(doctor:snapshot.data.docs[i].data()['name'])));

                        },
                      );

                    }
                );

              }
              if(snapshot.hasError)
              {
                return Text("error");
              }
              if(snapshot.connectionState==ConnectionState.waiting){
                return Text("loading");
              }

            }

        ),
      ),

    );
  }
}
