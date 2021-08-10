import 'package:flutter/material.dart';
import '../app_theme.dart';

class Screen3 extends StatefulWidget {
  const Screen3({@required this.animationController});
  final AnimationController animationController;

  @override
  _Screen3State createState() => _Screen3State();
}

class _Screen3State extends State<Screen3> {
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
              child: Center(child: Text('SCREEN 3')),
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
