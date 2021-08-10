import 'package:flutter/material.dart';
import '../app_theme.dart';

class Screen4 extends StatefulWidget {
  const Screen4({@required this.animationController});
  final AnimationController animationController;

  @override
  _Screen4State createState() => _Screen4State();
}

class _Screen4State extends State<Screen4> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            appBar(),
            Expanded(
              child: Center(child: Text('SCREEN 4')),
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
