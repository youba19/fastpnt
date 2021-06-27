import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart' as path;
import 'package:fastpnt/Screens/login.dart';
import 'package:fastpnt/widgets/changeScreens.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
class Mformul extends StatefulWidget {
  @override
  _MformulState createState() => _MformulState();
}
final GlobalKey<FormState> _formKey=GlobalKey<FormState>();
String p = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
bool obserText=true;
RegExp regExp = new RegExp(p);
FirebaseAuth auth = FirebaseAuth.instance;
String email="";
String password="";
class _MformulState extends State<Mformul> {

  Future<void> validation() async {
    final FormState _form=_formKey.currentState;
    if(!_form.validate()){
      try {

        await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx)=>Login1()));
      } on PlatformException catch (e){
        print(e.message.toString());

      }

    }
    else{
      print("non");

    }
  }
  bool showvalue=true;
  CollectionReference userref=FirebaseFirestore.instance.collection("Medcin");

  TextEditingController em=TextEditingController();
  TextEditingController nm=TextEditingController();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  List<ListItem> _dropdownItems = [
    ListItem(1, "Généraliste"),
    ListItem(2, "Pédiatre"),
    ListItem(3, "Dentiste"),
    ListItem(4, "Ophtalmologue"),
    ListItem(4, "Dermatologue"),
    ListItem(4, "Cardiologue"),
    ListItem(4, "Gynécologue")
  ];
  List<DropdownMenuItem<ListItem>> _dropdownMenuItems;
  ListItem _selectedItem;

  void initState() {
    super.initState();
    _dropdownMenuItems = buildDropDownMenuItems(_dropdownItems);
    _selectedItem = _dropdownMenuItems[0].value;

  }

  List<DropdownMenuItem<ListItem>> buildDropDownMenuItems(List listItems) {
    List<DropdownMenuItem<ListItem>> items = List();
    for (ListItem listItem in listItems) {
      items.add(
        DropdownMenuItem(
          child: Text(listItem.name,style:TextStyle(color: Colors.blue)),
          value: listItem,
        ),
      );
    }
    return items;
  }


  List gender=["Male","Female"];

  String select;

  Row addRadioButton(int btnValue, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Radio(
          activeColor: Theme.of(context).primaryColor,
          value: gender[btnValue],
          groupValue: select,
          onChanged: (value){
            setState(() {
              print(value);
              select=value;
            });
          },
        ),
        Text(title)
      ],
    );
  }

  File simpleImage;
  Future getImage() async {
    var tempImage=await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      simpleImage=tempImage;
    });
  }

UploadTask task;
File file;

  String usenamer;
  String adr;
  String urlDownload;

  @override
  Widget build(BuildContext context) {
    final fileName = file != null ? path.basename(file.path) : 'pas de fichier chasi';
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Form(
          key:_formKey,
          child: Container(
            height: 750,
            margin: EdgeInsets.symmetric(horizontal: 10),
            width: double.infinity,
            child: Column( mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children:<Widget> [

           Container(
               width: 150,
               height: 150,
               child: Image.asset('assets/dlog.png')),
                Text("S'inscrire",style: TextStyle(fontSize:45,fontWeight: FontWeight.bold),),
                TextFormField(
                  //   controller:nm,
                  onChanged: (value){
                    setState(() {
                       usenamer=value;
                    });
                  },
                  validator:(value){if(value=="") {
                    return"s'il vous plaît Entrez votre  nom";
                  }

                  else if(value.length < 6){
                    return "nom d'utilisateur trop court";

                  }
                  return "";
                  },
                  decoration: InputDecoration(
                    hintText: "Nom Utilisateur",

                    hintStyle: TextStyle(color:Colors.black),
                    border: OutlineInputBorder(),
                  ),
                ),
                TextFormField(
                  validator:(value){
                    if(value==""){
                      return "s'il vous plaît Entrez vote l'email";

                    }
                    else if(!regExp.hasMatch(value)) {

                      return"Email n'est pas valide";
                    }
                    return "";
                  },
                  //controller: em,
                  onChanged: (value){
                    setState(() {
                      email=value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: "Email",
                    hintStyle: TextStyle(color:Colors.black),
                    border: OutlineInputBorder(),
                  ),
                ),
                TextFormField(
                  obscureText: obserText,
                  validator:(value){if(value=="") {
                    return"s'il vous plaît Entrez le mot de passe";
                  }

                  else if(value.length < 8){
                    return "mot de passe  trop court";

                  }
                  return "";
                  },
                  onChanged: (value){
                          setState(() {
                            password=value;
                            print(password);
                          });
                        },
                  decoration: InputDecoration(
                    hintText: "Mot de passe",
                    suffixIcon: GestureDetector(
                      onTap: (){
                        setState(() {
                          obserText=!obserText;
                        });
                        FocusScope.of(context).unfocus();
                      },
                      child: Icon(obserText ==true ? Icons.visibility : Icons.visibility_off,color: Colors.black,),
                    ),
                    hintStyle: TextStyle(color:Colors.black),
                    border: OutlineInputBorder(),

                  ),
                ),



                      TextFormField(
                        //   controller:nm,
                        onChanged: (value){
                          setState(() {
                           adr=value;
                          });
                        },
                        validator:(value){if(value=="") {
                          return"s'il vous plaît Entrez votre  Adresse";
                        }

                        else if(value.length < 6){
                          return "";

                        }
                        return "";
                        },
                        decoration: InputDecoration(
                          hintText: "Adresse",

                          hintStyle: TextStyle(color:Colors.black),
                          border: OutlineInputBorder(),
                        ),
                      ),

                     Row(
                       children:<Widget> [
                         Text("Entrez votre Spécialité:             ",style:TextStyle(fontWeight: FontWeight.bold)),
                         Container(
                           padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                           height: 35,
                           decoration: BoxDecoration(
                               borderRadius: BorderRadius.circular(10.0),
                               color: Colors.white,

                               border: Border.all()),
                           child: DropdownButtonHideUnderline(
                             child: DropdownButton(

                                 value: _selectedItem,
                                 items: _dropdownMenuItems,
                                 onChanged: (value) {
                                   setState(() {
                                     _selectedItem = value;
                                   });
                                   print(_selectedItem.name);
                                 }),
                           ),
                         ),




                       ],
                     ),
                      Row(
                        children:<Widget> [
                          Text("Entrez votre Diplome:                ",style: TextStyle(fontWeight: FontWeight.bold),),
                          Column(
                            children:<Widget> [
                              OutlinedButton.icon(
                                onPressed: selectFile,
                                icon: Icon(Icons.link, size: 18,color: Colors.black,),
                                label: Text("Choisir un fichier",style: TextStyle(color: Colors.black),),
                              ),
                              Text(fileName),
                            ],
                          ),
                         /* OutlinedButton.icon(
                            onPressed:c,
                            icon: Icon(Icons.upload_file, size: 18),
                            label: Text("upload"),

                          ),*/
                        ],
                      ),

                Row(
                  children: <Widget>[
                    addRadioButton(0, 'Male'),
                    addRadioButton(1, 'Female'),

                  ],
                ),


                      SizedBox(height: 30,),

                      Container(
                        height: 45,
                        width: double.infinity,
                        child: RaisedButton(onPressed: () async{
                            if(file == null) return;
                            final fileName =path.basename(file.path);
                            final destination='files/$fileName';
                            task =  FirebaseApi.uploadFile(destination,file);

                            if(task != null) {
                            final snapshot =await task.whenComplete(() {} );
                            urlDownload= await snapshot.ref.getDownloadURL();
                            }

                            userref.add({"specialite": _selectedItem.name , "name":usenamer ,"genre": select ,"email": email,"password":password , "diplome":urlDownload,"valide":false});

                        /* final url= uploadtFile();
                          print(url);*/
                         // userref.add({"specialite": _selectedItem.name , "name":usenamer ,"genre": select ,"email": email,"password":password ,});
                          // ignore: unnecessary_statements
                        }, color:Colors.blueGrey[400],
                          child: Text("Valider"),
                        ),
                      ),






              ],
            ),
          ),
        ),
      ),
    );
  }


  Future selectFile() async{
    final result=await FilePicker.platform.pickFiles(allowMultiple:  false);
    if( result == null ) return;
    final path =result.files.single.path;
    setState(() {
      file=File(path);
    });
  }

  Future uploadtFile() async{
    if(file == null) return;
    final fileName =path.basename(file.path);
    final destination='files/$fileName';
  task =  FirebaseApi.uploadFile(destination,file);

    if(task == null) return;
    final snapshot =await task.whenComplete(() {} );
    final urlDownload= await snapshot.ref.getDownloadURL();
    return 'youba';
    print(urlDownload);
  }
 /* Widget enableUpload(){
    return Container(
      child: Column(
        children:<Widget>  [
          Image.file(simpleImage,height: 300.0, width:  300.0,),
          RaisedButton(
              elevation:7.0,
              child: Text('upload'),
              textColor: Colors.blue,
              onPressed: () async{
                final StorageReference firebasStorageRef = FirebaseStorage.instance.ref().child('adr.png');
                final StorageUploadTask task = firebaseStorageRef.putFile(simpleImage);
          }),
        ],
      ),
    );
  }*/
}

class FirebaseApi {
  static UploadTask uploadFile(String destination , File file){
    try{
     final ref = FirebaseStorage.instance.ref(destination);
     return ref.putFile(file);
    } on  FirebaseException catch (e){
      return null;
    }

  }
}
class ListItem {
  int value;
  String name;

  ListItem(this.value, this.name);
}