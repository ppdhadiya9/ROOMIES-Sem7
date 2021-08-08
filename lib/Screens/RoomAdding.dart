import 'package:flutter/material.dart';
import 'package:flutter_app/app_theme.dart';


class RoomAdding extends StatefulWidget {
  @override
  _RoomAddingState createState() => _RoomAddingState();
}

class _RoomAddingState extends State<RoomAdding> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Color(0xFFF2F3F8),
      child: Padding(
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
                Center(child: Text('Room Adding')),
              ),
            ]),

      ),
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

