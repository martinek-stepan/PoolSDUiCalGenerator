import 'dart:io';
import 'dart:math';

import 'package:PoolCalGenerator/ScheduleEvent.dart';
import 'package:PoolCalGenerator/VersitMaker.dart';

import 'package:date_calendar/date_calendar.dart';

void generate(Map<int,List<ScheduleEvent>> eventsMap, String iCalPath)
{
  print("iCalGenerator: Begin...");
  VersitMaker vCal = VersitMaker.vCal();

  int currentWeek = _currentWeekOfYear();
  int firstCalWeek = eventsMap.keys.reduce(min);
  int lastCalWeek = eventsMap.keys.reduce(max);

  int year = DateTime.now().year;

  // Case when we have schedule for next year in the end of year
  if (currentWeek >= 49 && firstCalWeek < 10)
  {
    year++;
  }
  print("iCalGenerator: Parsing weeks $firstCalWeek - $lastCalWeek for year $year");

  eventsMap.forEach((week, events) {
    events.forEach((event){

        Calendar cal = GregorianCalendar(year);
        int wd = cal.weekday-1;
        Calendar cal1 = cal.addDays(7-(cal.weekday-1));
        Calendar cal2 = cal1.addWeeks(week-1);
        int minus = cal.weekday >= 6 ? 0 : 7;
        Calendar cal3 = cal2.addDays(event.day-minus);

      vCal.addVersit(VersitMaker.vEvent(cal3.toDateTimeUtc(), event.start, event.duration, event.students));
    });
  });

  print("iCalGenerator: Saving iCal file...");
  File ics = new File(iCalPath);
  ics.writeAsStringSync(vCal.toString());

  print("iCalGenerator: Done!");
}

int _currentWeekOfYear()
{
  final date = DateTime.now();
  final startOfYear = new DateTime(date.year, 1, 1, 0, 0);
  final diff = date.difference(startOfYear);
  var weeks = (diff.inDays / 7).ceil();

  return weeks;
}
