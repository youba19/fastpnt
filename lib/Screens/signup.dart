import 'package:fastpnt/Screens/MedcinFormulaire.dart';
import 'package:fastpnt/Screens/login.dart';
import 'package:fastpnt/widgets/changeScreens.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';


class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}
final GlobalKey<FormState> _formKey=GlobalKey<FormState>();
String p = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
bool obserText=true;
RegExp regExp = new RegExp(p);
FirebaseAuth auth = FirebaseAuth.instance;
String email="";
String password="";
class _SignUpState extends State<SignUp> {
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Form(
          key:_formKey,
          child: Container(
            child: Column(
              children:<Widget> [
                Container(
                  height:220 ,
                  width: double.infinity,

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text("S'inscrire",style: TextStyle(fontSize: 50,fontWeight: FontWeight.bold),),

                    ],
                  ),
                ),SizedBox(height: 20,),
                Container(
                  height: 400,
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  width: double.infinity,

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      TextFormField(
                     //   controller:nm,
                        onChanged: (value){
                          setState(() {
                            password=value;
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
                        /*onChanged: (value){
                          setState(() {
                            password=value;
                            print(password);
                          });
                        },*/
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
                        validator:(value){if(value=="") {
                          return"s'il vous plaît Entrez votre numero de téléphone";
                        }

                          else  if(value.length < 11){
                            return "le numéro de téléphone doit être 11 chiffre";

                          }
                          return "";
                        },
                        decoration: InputDecoration(
                          hintText: "Numéro Téléphone",
                          hintStyle: TextStyle(color:Colors.black),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      Row(
                        children:<Widget> [
                          Checkbox(
                            value: this.showvalue,
                            onChanged: (bool value) {
                              setState(() {
                                this.showvalue = value;
                                print(this.showvalue);
                              });
                            },
                          ),

                          Text("je suis medcin"),
                        ],
                      ),


                      Container(
                        height: 45,
                          width: double.infinity,
                        child: RaisedButton(onPressed: () async {
                          if(showvalue==false){
                            validation();
                          }
                         else {
                           // userref.add({"specialite": email , "name":password});
                           print("je suis medcin");
                           print(email);
                            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx)=>Mformul()));
                          }

                        }, color:Colors.blueGrey[400],
                          child: Text("Connexion"),
                        ),
                      ),
                      Row(
                        children: [
                          Text("j'ai dèja un compte"),
                          SizedBox(width: 10,),
                          GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx)=>Login1()));
                              },
                              child:Text("connexion",style: TextStyle(color: Colors.cyan,fontSize: 20,fontWeight:FontWeight.bold ),)
                          )
                        ],
                      ),


                    ],
                  ),

                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
