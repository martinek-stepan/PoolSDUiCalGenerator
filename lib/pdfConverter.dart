import 'dart:io';
import 'package:dio/dio.dart';

void convert(String pdfPath, String xlsxPath) async {
  print("Converter: Begin...");
  Dio dio = new Dio();
  FormData formData = new FormData.from({
    "OutputFormat": "Excel",
    "NonTableDataMode": "exclude",
    "DynamicFile": new UploadFileInfo(new File(pdfPath), "pool.pdf")
  });
  Options options = Options();
  options.headers.addAll({'Accept': 'application/json'});
  print("Converter: Send request...");
  Response response = await dio.post("https://simplypdf.com/api/convert", data: formData, options: options);
  if (response.statusCode != 200)
  {
    throw "Converter: Https fail, response code: ${response.statusCode}";
  }

  final int id =  response.data['id'];
  String status = response.data['status'];

  print("Converter: Recieved id($id) & status($status)...");
  const int MAX_ATTEMPTS = 10;
  const int CHECK_TIMEOUT = 3;

  for(int i = 0; i < MAX_ATTEMPTS && status != 'ready'; i++)
  {
    sleep(Duration(seconds: CHECK_TIMEOUT));
    print("Converter: Retrieve attempt nr: ${i+1}");
    response = await dio.get("https://simplypdf.com/api/status/$id", options: options);

    if (response.statusCode != 200)
    {
      print("Converter: Https fail, response code: ${response.statusCode}");
      continue;
    }
    status = response.data['status'];
  }

  if (status != 'ready')
  {
    throw "Converter: Converting failed, run out of retrieve attempts";
  }

  response = await dio.download("https://simplypdf.com/api/download/$id", xlsxPath, options: options, onProgress:
      (int received, int total){
    print("Converter: Downloading - $received/$total");
  }
  );

  print("Converter: Done!");
}
