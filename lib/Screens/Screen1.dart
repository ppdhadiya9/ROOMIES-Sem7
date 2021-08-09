import 'package:flutter/material.dart';
import '../Bottom_Navigation/tab_icon_data.dart';
import 'package:flutter_app/app_theme.dart';

class MyHomePage extends StatefulWidget {

  final AnimationController animationController;
  const MyHomePage({@required this.animationController});


  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  bool multiple = true;
  List<TabIconData> tabIconsList = TabIconData.tabIconsList;
  Widget tabBody = Container(
    color: Color(0xFFF2F3F8),
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery
          .of(context)
          .padding
          .top),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            appBar(),
            Expanded(
              child:
              Center(child: Text('SCREEN 1')),
            ),
          ]),

    );
  }

  Widget appBar() {
    return SizedBox(
      height: AppBar().preferredSize.height,
      child: Center(
          child: Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text(
              'ROOMIES',
              style: TextStyle(
                fontSize: 22,
                color: AppTheme.darkText,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      );
  }
}
