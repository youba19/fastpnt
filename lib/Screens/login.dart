import 'package:fastpnt/Screens/signup.dart';
import 'package:fastpnt/widgets/changeScreens.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'home.dart';
class Login extends StatefulWidget {
  @override


  _LoginState createState() => _LoginState();
}
final GlobalKey<FormState> _formKey=GlobalKey<FormState>();
String p = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
bool obserText=true;
RegExp regExp = new RegExp(p);
FirebaseAuth auth = FirebaseAuth.instance;
String email="";
String password="";

@override
class _LoginState extends State<Login> {

  Future<void> validation() async {
   // final FormState? _form=_formKey.currentState;
    print(email); if(!_formKey.currentState.validate()){
        await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx)=>Home()));
    }
    else{
      print("non");

    }
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
@override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: <Widget>[
              Container(
                height: 300,
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                  children: <Widget>[
                    Text("Connexion",style: TextStyle(fontSize: 50,fontWeight: FontWeight.bold)),
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
                        onChanged: (value){
                        setState(() {
                        email=value;
                        });   },
                      decoration: InputDecoration(
                        hintText: "Email Ou Nom Utillisateur"
                            ,
                        hintStyle: TextStyle(color:Colors.black),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    TextFormField(

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
                    Container(
                      height: 45,
                      width: double.infinity,
                      child: RaisedButton( onPressed: ()  async {
                        print(email);
                            validation();

                        }
                      , color:Colors.blueGrey[400],
                        child: Text("S'inscrire"),
                        
                      ),
                    ),
                    Row(
                      children: [
                        Text("j'ai pas de compte"),
                        SizedBox(width: 10,),
                        GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx)=>SignUp()));
                            },
                            child:Text("S'inscrire",style: TextStyle(color: Colors.cyan,fontSize: 20,fontWeight:FontWeight.bold ),)
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
    );
  }
}
