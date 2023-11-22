import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveRecord(Record record) async {
  final prefs = await SharedPreferences.getInstance();
  List<String>? recordList = prefs.getStringList("record");
  recordList ??= [];
  recordList.add("${record.name}#${record.time}");
  prefs.setStringList("record", recordList);
}

Future<List<Record>> getRecords() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String>? recordList = prefs.getStringList("record");
  List<Record> records = [];
  recordList?.forEach((element) {
    List<String> record = element.split("#");
    records.add(Record(name: record[0], time: record[1]));
  });
  return records;
}

Future<void> clearRecord(int index) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String>? recordList = prefs.getStringList("record");
  recordList?.removeAt(index);
  prefs.setStringList("record", recordList ?? []);
}

Future<void> clearAllRecords() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setStringList("record", []);
}

class Record {
  String name;
  String time;
  Record({required this.name, required this.time});
}
