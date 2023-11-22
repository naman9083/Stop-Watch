import 'package:flutter/material.dart';
import 'package:searchable_listview/searchable_listview.dart';
import 'package:timer_task/shared_services.dart';

class Records extends StatefulWidget {
  const Records({Key? key}) : super(key: key);

  @override
  State<Records> createState() => _RecordsState();
}

class _RecordsState extends State<Records> {
  List<Record> recordList = [];
  List<Record> searchList = [];
  handleSearch(String name) {
    setState(() {
      searchList = recordList
          .where((element) =>
              element.name.toLowerCase().contains(name.toLowerCase()))
          .toList();
    });
  }

  final TextEditingController _controller = TextEditingController();
  @override
  void initState() {
    super.initState();

    getRecords().then((value) {
      setState(() {
        recordList = value;
      });
      print(recordList[0].time);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Column(
        //search bar
        children: [
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                controller: _controller,
                onChanged: (value) {
                  handleSearch(value);
                },
                decoration: InputDecoration(
                    hintText: "Search",
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              )),
          Expanded(
            child: ListView.builder(
              itemCount:
                  searchList.isEmpty ? recordList.length : searchList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Delete Record"),
                          content: const Text(
                              "Are you sure you want to delete this record?"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () {
                                clearRecord(index).then((value) {
                                  setState(() {
                                    recordList.removeAt(index);
                                  });
                                  Navigator.pop(context);
                                });
                              },
                              child: const Text("Delete"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  title: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(12.0),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 5.0, vertical: 0),
                    decoration: BoxDecoration(
                      color: index % 2 == 0
                          ? const Color(0xFFF2F2F2)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          searchList.isEmpty
                              ? recordList[index].name
                              : searchList[index].name,
                          style: const TextStyle(fontSize: 24.0),
                        ),
                        Text(
                          searchList.isEmpty
                              ? recordList[index].time
                              : searchList[index].time,
                          style: const TextStyle(fontSize: 24.0),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    ));
  }
}
