import 'package:flutter/material.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import '../../shared_services.dart';

class TImer extends StatefulWidget {
  const TImer({Key? key}) : super(key: key);

  @override
  State<TImer> createState() => _TImerState();
}

class _TImerState extends State<TImer> {
  final StopWatchTimer _stopWatchTimer = StopWatchTimer();
  final TextEditingController _titleController = TextEditingController();
  final List<String> _laps = [];
  bool resetButton = true;
  void _addLap() {
    setState(() {
      _laps.add(
        StopWatchTimer.getDisplayTime(
          _stopWatchTimer.rawTime.value,
          hours: true,
          minute: true,
          second: true,
          milliSecond: false,
        ),
      );
    });
  }

  void _stopTimer() {
    setState(() {
      _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
      resetButton = true;
    });
  }

  void _startTimer() {
    setState(() {
      _stopWatchTimer.onExecute.add(StopWatchExecute.start);
      resetButton = false;
    });
  }

  void _resetTimer() {
    setState(() {
      _laps.clear();
      _stopWatchTimer.onExecute.add(StopWatchExecute.reset);
    });
  }

  @override
  void initState() {
    super.initState();
    _stopWatchTimer.rawTime.listen((value) => setState(() {}));
  }

  @override
  void dispose() {
    _stopWatchTimer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height; // get height of screen
    return Scaffold(
      //bottom sheet to save laps
      body: Column(
        children: [
          StreamBuilder<int>(
            stream: _stopWatchTimer.rawTime,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    StopWatchTimer.getDisplayTime(snapshot.data!)
                        .toString()
                        .substring(0, 8),
                    style:
                        const TextStyle(fontSize: 48.0, fontFamily: 'Roboto'),
                  ),
                );
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                resetButton
                    ? InkWell(
                        onTap: _resetTimer,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(50),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 2,
                                blurRadius: 3,
                                offset: const Offset(
                                    0, 1), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Image.asset(
                            'assets/images/reset.png',
                            width: 100,
                            height: 100,
                          ),
                        ),
                      )
                    : InkWell(
                        onTap: _stopWatchTimer.isRunning ? _addLap : null,
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(50),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 1,
                                blurRadius: 3,
                                offset: const Offset(
                                    0, .5), // changes position of shadow
                                // changes position of shadow
                              ),
                            ],
                          ),
                          child: Image.asset(
                            'assets/images/lap.png',
                            width: 100,
                            height: 100,
                          ),
                        ),
                      ),
                InkWell(
                  onTap: () {
                    if (_stopWatchTimer.isRunning) {
                      _stopTimer();
                    } else {
                      _startTimer();
                    }
                  },
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset:
                              const Offset(0, .5), // changes position of shadow
                        ),
                      ],
                    ),
                    child: _stopWatchTimer.isRunning
                        ? Image.asset(
                            'assets/images/stop.png',
                            width: 100,
                            height: 100,
                          )
                        : Image.asset(
                            'assets/images/start.png',
                            width: 100,
                            height: 100,
                          ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _laps.length,
              itemBuilder: (context, index) => ListTile(
                onTap: () {
                  _titleController.text = "Lap ${index + 1}";
                  showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return Container(
                          height: height * 0.23,
                          width: double.infinity,
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, top: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 2,
                                blurRadius: 3,
                                offset: const Offset(
                                    0, 1), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                //sheet icon

                                Container(
                                  height: 5,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Save Lap ${index + 1} in records?",
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Roboto',
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                //save record button
                                //image button
                                InkWell(
                                  onTap: () => {
                                    Navigator.pop(context),
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Row(
                                              children: [
                                                const Text('Title Record'),
                                                const Spacer(),
                                                IconButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    icon:
                                                        const Icon(Icons.close))
                                              ],
                                            ),
                                            content: TextField(
                                              controller: _titleController,
                                              decoration: const InputDecoration(
                                                  border: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.grey)),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: Color(
                                                                  0xFF008392))),
                                                  hintText: 'Enter title'),
                                            ),
                                            actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text('Cancel',
                                                      style: TextStyle(
                                                          color: Colors.grey))),
                                              TextButton(
                                                  onPressed: () {
                                                    saveRecord(Record(
                                                            name:
                                                                _titleController
                                                                    .text,
                                                            time: _laps[index]
                                                                .toString()))
                                                        .then((value) => {
                                                              Navigator.pop(
                                                                  context)
                                                            });
                                                  },
                                                  child: const Text('Save',
                                                      style: TextStyle(
                                                          color: Color(
                                                              0xFF008392)))),
                                            ],
                                          );
                                        })
                                  },
                                  child: Image.asset(
                                    'assets/images/save.png',
                                    width: 350,
                                    height: 50,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                InkWell(
                                  child: Image.asset(
                                    'assets/images/cancel.png',
                                    width: 350,
                                    height: 50,
                                  ),
                                ),
                              ] //text button
                              ),
                        );
                      });
                },
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
                title: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(12.0),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 5.0, vertical: 0),
                  decoration: BoxDecoration(
                    color:
                        index % 2 == 0 ? const Color(0xFFF2F2F2) : Colors.white,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Lap ${index + 1}',
                        style: const TextStyle(fontSize: 24.0),
                      ),
                      Text(
                        _laps[index],
                        style: const TextStyle(fontSize: 24.0),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//
//
// class SearchBar extends StatelessWidget {
//   const SearchBar({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return SearchableList<Actor>(
//       onPaginate: () async {
//         await Future.delayed(const Duration(milliseconds: 1000));
//
//       },
//       builder: (Actor actor) => ActorItem(actor: actor),
//       loadingWidget: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: const [
//           CircularProgressIndicator(),
//           SizedBox(
//             height: 20,
//           ),
//           Text('Loading actors...')
//         ],
//       ),
//       errorWidget: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: const [
//           Icon(
//             Icons.error,
//             color: Colors.red,
//           ),
//           SizedBox(
//             height: 20,
//           ),
//           Text('Error while fetching actors')
//         ],
//       ),
//       asyncListCallback: () async {
//         await Future.delayed(
//           const Duration(
//             milliseconds: 10000,
//           ),
//         );
//         return actors;
//       },
//       asyncListFilter: (q, list) {
//         return list
//             .where((element) => element.name.contains(q))
//             .toList();
//       },
//
//       onRefresh: () async {},
//       onItemSelected: (Actor item) {},
//       inputDecoration: InputDecoration(
//         labelText: "Search Actor",
//         fillColor: Colors.white,
//         focusedBorder: OutlineInputBorder(
//           borderSide: const BorderSide(
//             color: Colors.blue,
//             width: 1.0,
//           ),
//           borderRadius: BorderRadius.circular(10.0),
//         ),
//       ),
//     );
//   }
// }
