import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

class CardModel {
  String doctor;
  int cardBackground;
  var cardIcon;

  CardModel(this.doctor, this.cardBackground, this.cardIcon);
}

List<CardModel> cards = [

  new CardModel("Cardiologue", 0xFFBC243C, FlutterIcons.heart_ant),
  new CardModel("Dentiste", 0xFF34568B, FlutterIcons.tooth_mco),
  new CardModel("Ophtalmologue", 0xFFFF6F61, TablerIcons.eye),
  new CardModel("Généraliste", 0xFF88B04B, Icons.wheelchair_pickup_sharp),
  new CardModel("Cardiologue", 0xFFF7CAC9, FlutterIcons.baby_faw5s),
];