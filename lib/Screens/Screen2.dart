
import 'package:flutter/material.dart';
import '../app_theme.dart';

class Screen2 extends StatefulWidget {
 const Screen2({@required this.animationController});
 final AnimationController animationController;

  @override
  _Screen2State createState() => _Screen2State();
}

class _Screen2State extends State<Screen2> {
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
              Center(child: Text('SCREEN 2')),
            ),
          ]),

    );
  }

  Widget appBar() {
    return SizedBox(
      height: AppBar().preferredSize.height,
      child: Expanded(
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
      ),
    );
  }
}
