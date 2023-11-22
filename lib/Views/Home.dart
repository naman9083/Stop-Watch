import 'package:flutter/material.dart';
import 'package:timer_task/Views/Tabs/Records.dart';
import 'package:timer_task/Views/Tabs/Timer.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Color bgColor = Colors.white;
  Color textColor = Colors.black;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height; // get height of screen
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            scrolledUnderElevation: 10,
            backgroundColor: Colors.transparent,

            //disable shadow
            elevation: 0,

            bottom: TabBar(
              dividerColor: Colors.transparent,
              //stop scroll physics

              splashBorderRadius: BorderRadius.circular(10),
              overlayColor: MaterialStateProperty.all(Colors.transparent),

              onTap: (index) {
                // Tab index when user select it, it start from zero
                switch (index) {
                  case 0:
                    setState(() {
                      bgColor = Colors.white;
                      textColor = Colors.black;
                    });
                    break;
                  case 1:
                    setState(() {
                      bgColor = Colors.black;
                      textColor = Colors.white;
                    });
                    break;
                }
              },
              indicatorColor: Colors.transparent,
              tabs: [
                Tab(
                    icon: Container(
                        padding: const EdgeInsets.all(10),
                        width: width * 0.5,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: textColor,
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
                        child: Center(
                            child: Text(
                          "Timer",
                          style: TextStyle(color: bgColor, fontSize: 16),
                        )))),
                Tab(
                    icon: Container(
                        padding: const EdgeInsets.all(10),
                        width: width * 0.50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 2,
                                blurRadius: 3,
                                offset: const Offset(
                                    0, 1), // changes position of shadow
                              ),
                            ],
                            color: bgColor),
                        child: Center(
                            child: Text(
                          "Records",
                          style: TextStyle(color: textColor, fontSize: 16),
                        )))),
              ],
            ),
          ),
          body: const TabBarView(
            // The TabBarView displays a widget for each tab.
            // https://api.flutter.dev/flutter/material/TabBarView-class.html
            children: [
              TImer(),
              Records(),
            ],
          ),
        ),
      ),
    );
  }
}
