import 'dart:io';
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';
import 'package:PoolCalGenerator/ScheduleEvent.dart';

void _addNewEntry(Map<int,List<ScheduleEvent>> mapa, int week, int hour, int day, bool students)
{
  if(mapa.containsKey(week))
  {
    for (ScheduleEvent p in mapa[week])
    {
      if (hour == (p.start+p.duration) && students == p.students && day == p.day)
      {
        p.duration += 1;
        return;
      }
    }
    mapa[week].add(ScheduleEvent(hour, day));
  }
  else
  {
    mapa[week] = [ScheduleEvent(hour, day)];
  }
}

Map<int,List<ScheduleEvent>> parse(String xlsxPath)
{
  print("XLSXParser: Begin...");
  var bytes = new File(xlsxPath).readAsBytesSync();
  var decoder = new SpreadsheetDecoder.decodeBytes(bytes);
  var table = decoder.tables['Table 1'];
  Map<int,List<ScheduleEvent>> mapa = Map();
  int hour = 8;
  List<String> days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Caturday', 'Sunday'];

  List<List<String>> preprocesedTable = _preprocessTable(table.rows);

  for (List<String> row in preprocesedTable)
  {
    //print(hour);
    int day = 0;
    for (String column in row)
    {
      //print(days[day]);
      //print(column);
      bool students = !column.contains("All weeks only SDU employees");
      List<String> parts = column.replaceAll("\n",",").replaceAll(RegExp("[^0-9,]", multiLine: true), "").split(',');
      for (String part in parts)
      {
        if (part.isEmpty)
        {
          continue;
        }

        try {
          int week = int.tryParse(part);
          _addNewEntry(mapa, week, hour, day, students);
        }
        catch(ex)
        {
          print("XLSXParser: Failed parse part for ${days[day]} $hour");
        }
      }
      day++;
    }
    hour++;
  }

  print("XLSXParser: Done!");
  return mapa;
}

List<List<String>> _preprocessTable(List<List> rows) {
  List<List<String>> table = [];

  // Skip first row with days
  for (int i = 1; i < rows.length; i++)
  {
    List<String> row = [];
    // Skip first column (hours)
    for (int j = 1; j < rows[i].length; j++)
    {
      row.add(rows[i][j] as String);
    }
    table.add(row);
  }
  return table;
}