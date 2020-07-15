import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class VersitMaker
{
  String data = "";
  String type = "";

  VersitMaker.vCal()
  {
    type = "VCALENDAR";
    data = "BEGIN:$type\r\n";
    addValue("PRODID", "Swimming pool schedule");
    addValue("VERSION", "2.0");
  }

  VersitMaker.vEvent(DateTime start, int hour, int duration, bool students)
  {
    type = "VEVENT";
    data = "BEGIN:$type\r\n";
    addValue("class", "PUBLIC");
    addValue("created", zuluDate(DateTime.now()));
    addValue("dtstamp", zuluDate(DateTime.now()));
    addValue("uid",Uuid().v1());
    addValue("dtstart", zuluDate(start, hour));
    addValue("geo", "55.3699966;10.43005368");
    addValue("description", "Swimming pool is open for ${students ? "students" : "employees"} for free.");
    addValue("location", "Svømmehallen Universitetet - Campusvej 55, 5230 Odense");
    addValue("summary", students ? "🏊‍" : "🏊‍💼");
    addValue("TRANSP", "TRANSPARENT");
    addValue("url", "https://mitsdu.dk/da/vejledning/faciliteter/odense/svoemmehal");
    addValue("DURATION", "PT${duration}H");
    addValue("categories", "SWIMMING,${students ? "STUDENTS" : "EMPLOYEES"}");
  }

  String zuluDate(DateTime time, [int hour])
  {
    var formatter = hour == null ? new DateFormat("yyyyMMdd'T'Hms") : new DateFormat("yyyyMMdd'T${hour < 10 ? "0$hour" : "$hour"}0000'");;
    return formatter.format(time);
  }

  void addVersit(VersitMaker versit)
  {
    data += versit.toString();
  }

  void addValue(String type, String value)
  {
    data += "${type.toUpperCase()}:$value\r\n";
  }

  @override
  String toString()
  {
    return data + "END:$type\r\n";
  }

}