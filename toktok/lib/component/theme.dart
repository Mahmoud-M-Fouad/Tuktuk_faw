import 'package:flutter/material.dart';

headingStyle({
  required Color color,
  required double fontSize,
}){
  return  TextStyle(
    fontSize: fontSize,
    fontWeight: FontWeight.w300,
    overflow:TextOverflow.fade ,
    color:color,
  );
}