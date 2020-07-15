import 'dart:async';
import 'package:html/dom.dart';
import 'package:dio/dio.dart';
import 'package:HTMLSelecter/HTMLSelecter.dart';

Future download(String downloadPath) async {
  print("PDFDownloader: Begin...");
  Dio dio = Dio();
  print("PDFDownloader: Getting page with schedules...");
  Response<String> response = await dio.get("https://mitsdu.dk/da/vejledning/faciliteter/odense/svoemmehal");
  print("PDFDownloader: Parsing page with schedules...");
  for(Element element in $(".article__body a", response.data))
  {
    if (element.innerHtml == "Skema med ledige tider engelsk version")
    {
      String path = element.attributes["href"];
      if (!path.startsWith("http"))
      {
        path = "https://mitsdu.dk"+path;
      }
      await dio.download(path, downloadPath, onProgress: (int received, int total){
        print("PDFDownloader: Downloading pdf schedule - $received/$total");
      });
      break;
    }
  }
  print("PDFDownloader: Done!");
}