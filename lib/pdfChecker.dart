
import 'dart:async';
import 'dart:io';

import 'package:crypto/crypto.dart';

Future<bool> check(String newPdfPath, String oldPdfPath) async {
  print("PDFChecker: Begin...");

  //Regenerate calendar on new year - if still old one weeks are far ahead, if new one we make sure we have correct year set
  DateTime today = DateTime.now();
  if (today.day == 1 && today.month == 1) {
    print("PDFChecker: Done! New year condition fulfilled");
    return false;
  }
  File oldPDF = File(oldPdfPath);

  if(!await oldPDF.exists())
  {
    print("PDFChecker: Done! Missing old file condition fulfilled");
    return false;
  }

  File newPDF = File(newPdfPath);

  var oldHash = md5.bind(oldPDF.openRead()).first;
  var newHash = md5.bind(newPDF.openRead()).first;

  bool res = await oldHash == await newHash;

  print("PDFChecker: Done! Files are ${res ? "same" : "different"}");
  return res;
}