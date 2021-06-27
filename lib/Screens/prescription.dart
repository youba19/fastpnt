import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fastpnt/Screens/Doctorpage.dart';
import 'package:fastpnt/Screens/prevPrescription.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Prescription extends StatefulWidget {
  final useremail;
  final name;
  final docName;
  final time;
  final docID;

  const Prescription(
      {Key key, this.useremail, this.name, this.docName, this.time, this.docID})
      : super(key: key);
  @override
  _PrescriptionState createState() => _PrescriptionState();
}

class _PrescriptionState extends State<Prescription> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _controllerFee = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  FirebaseAuth _auth = FirebaseAuth.instance;
  User user;

  Future<void> _getUser() async {
    user = _auth.currentUser;
  }

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: Text(
        "OK",
        style: GoogleFonts.lato(fontWeight: FontWeight.bold),
      ),
      onPressed: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Doctorpage(),
          ),
        );
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        "Done!",
        style: GoogleFonts.lato(
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text(
        "Prescription added successfully.",
        style: GoogleFonts.lato(),
      ),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
  Future<void> deleteAppointment(String docID) {
    return FirebaseFirestore.instance
        .collection('appointments')
        .doc(user.email.toString())
        .collection('all')
        .doc(docID)
        .delete();
  }
  Future<void> addPrescription(String docID) async {
    FirebaseFirestore.instance
        .collection('appointments-doc')
        .doc(user.email).collection('all-doc').doc(docID)
        .update({
      'valide':true,
    },);
   /* FirebaseFirestore.instance
        .collection('appointments')
        .doc(user.email.toString())
        .collection('pending')
        .doc(docID)
        .update(
      {
        'valide':true,
      }
    );*/
  }


  Future<void> deleteAppointmentDoc(String docID) {
    return FirebaseFirestore.instance
        .collection("appointments-doc")
        .where("docid", isEqualTo: docID)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        FirebaseFirestore.instance
            .collection("appointments-doc")
            .doc(element.id)
            .delete()
            .then((value) {
          print("Success!");
        });
      });
    });

  }
  @override
  Widget build(BuildContext context) {
    var meetName = widget.name;
    meetName = widget.name.replaceAll(RegExp('\\s+'), '_');

    print(Timestamp.now());

    return Scaffold(
      appBar: AppBar(
        title: Text("Prescription",
            style: GoogleFonts.lato(
                color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Container(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('appointments-doc')
                      .doc(widget.docName)
                      .collection('all-doc')
                    //  .orderBy('docID')
                      .startAt([widget.docID]).endAt(
                          [widget.docID + '\uf8ff']).snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) return Container();
                    if (snapshot.data.size != 0) {
                      return Container(
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PrevPrescription(
                                  email: widget.useremail,
                                  docID: widget.docID,
                                ),
                              ),
                            );
                          },
                          child: Text(
                            "See Previous Prescriptions",
                            style: GoogleFonts.lato(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Patient Name",
                        style: GoogleFonts.lato(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(top: 10),
                        width: MediaQuery.of(context).size.width,
                        height: 40,
                        color: Colors.grey[200],
                        child: Text(
                          widget.name,
                          style: GoogleFonts.lato(fontSize: 18),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                         /* Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SeeMedicalRecord(
                                      email: widget.useremail,
                                    )),
                          );*/
                        },
                        child: Text(
                          "See Patient's Medical Record",
                          style: GoogleFonts.lato(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Time",
                        style: GoogleFonts.lato(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(top: 10),
                        width: MediaQuery.of(context).size.width,
                        height: 40,
                        color: Colors.grey[200],
                        child: Text(
                          widget.time.toDate().toString(),
                          style: GoogleFonts.lato(fontSize: 18),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Text(
                        "Add Prescription",
                        style: GoogleFonts.lato(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      TextFormField(
                        controller: _controller,
                        keyboardType: TextInputType.multiline,
                        maxLines: 5,
                        style: GoogleFonts.lato(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.only(left: 10, top: 10, bottom: 10),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey[200],
                          hintText: 'Add Prescription',
                          hintStyle: GoogleFonts.lato(
                            color: Colors.black26,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value.isEmpty)
                            return 'Please Add the Prescription';
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Text(
                        "Fees",
                        style: GoogleFonts.lato(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      TextFormField(
                        controller: _controllerFee,
                        keyboardType: TextInputType.number,
                        style: GoogleFonts.lato(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.only(left: 10, top: 10, bottom: 10),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey[200],
                          hintText: 'Add fees in ₹',
                          hintStyle: GoogleFonts.lato(
                            color: Colors.black26,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value.isEmpty) return 'Please Add the Fees';
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: Colors.blue[900],
                            borderRadius: BorderRadius.circular(12)),
                        child: TextButton(
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              addPrescription(widget.docID);
                           //   deleteAppointmentDoc(widget.docID);
                            //  deleteAppointment(widget.docName);
                              Navigator.pop(context);
                            }
                          },
                          child: Text(
                            "Add Prescription",
                            style: GoogleFonts.lato(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Divider(
                        color: Colors.grey,
                      ),
                      SizedBox(
                        height: 15,
                      ),

                      SizedBox(
                        height: 25,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
