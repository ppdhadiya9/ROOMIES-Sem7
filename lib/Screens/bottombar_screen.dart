import 'package:flutter/material.dart';

import '../Bottom_Navigation/bottom_bar_view.dart';
import 'package:flutter_app/Screens/RoomAdding.dart';
import '../Bottom_Navigation/tab_icon_data.dart';
import 'Screen1.dart';
import 'Screen2.dart';
import 'package:flutter_app/Screens/Screen3.dart';
import 'package:flutter_app/Screens/Screen4.dart';

class FitnessAppHomeScreen extends StatefulWidget {


  @override
  _FitnessAppHomeScreenState createState() => _FitnessAppHomeScreenState();
}

class _FitnessAppHomeScreenState extends State<FitnessAppHomeScreen>
    with TickerProviderStateMixin {
  List<TabIconData> tabIconsList = TabIconData.tabIconsList;

  Widget tabBody = Container(
    color: Color(0xFFF2F3F8),
  );

  AnimationController animationController;
  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    for (final TabIconData tab in tabIconsList) {
      tab.isSelected = false;
    }
    tabIconsList[0].isSelected = true;
    tabBody = MyHomePage(animationController: animationController);
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Color(0xFFF2F3F8),
      child: FutureBuilder<bool>(
        future: getData(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox();
          } else {
            return Stack(
              children: <Widget>[
                tabBody,
                bottomBar(),
              ],
            );
          }
        },
      ),
    );
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    return true;
  }

  Widget bottomBar() {
    return Column(
      children: <Widget>[
        const Expanded(
          child: SizedBox(),
        ),
        BottomBarView(
          tabIconsList: tabIconsList,
          addClick: () {
           setState(() {
             Navigator.push(
               context,
               MaterialPageRoute(builder: (context) => RoomAdding()),
             );
           });
          },
          changeIndex: (int index) {
            if (index == 0) {
              animationController.reverse().then<dynamic>((_) {
                if (mounted) {
                  setState(() {
                    tabBody =
                        MyHomePage(animationController: animationController);
                  });
                }
                return;
              });
            }
            else if (index == 1 ) {
              animationController.reverse().then<dynamic>((_) {
                if (mounted) {
                  setState(() {
                    tabBody = Screen2(
                        animationController: animationController);
                  });
                }
                return;
              });
            }
            else if (index == 2 ) {
              animationController.reverse().then<dynamic>((_) {
                if (mounted) {
                  setState(() {
                    tabBody = Screen3(
                        animationController: animationController);
                  });
                }
                return;
              });
            }
            else if (index == 3 ) {
              animationController.reverse().then<dynamic>((_) {
                if (mounted) {
                  setState(() {
                    tabBody = Screen4(
                        animationController: animationController);
                  });
                }
                return;
              });
            }
          },
        ),
      ],
    );
  }
}