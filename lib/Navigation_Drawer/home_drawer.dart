import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/login_signup/Login.dart';
import 'package:flutter_app/login_signup/Login_Screen.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../app_theme.dart';

class HomeDrawer extends StatefulWidget {
  const HomeDrawer({
    @required this.screenIndex,
    @required this.iconAnimationController,
    @required this.callBackIndex,
  });

  final AnimationController iconAnimationController;
  final DrawerIndex screenIndex;
  final Function(DrawerIndex) callBackIndex;

  @override
  _HomeDrawerState createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  FirebaseAuth _auth2 = FirebaseAuth.instance;

  User user;
  var userEmail;
  var userDisplayname;
  var userId;
  var userPhoto;

  List<DrawerList> drawerList;
  @override
  void initState() {
    user = _auth2.currentUser;
    userEmail = user.email;
    userDisplayname = user.displayName;
    userId = user.uid;
    userPhoto = user.photoURL;
    super.initState();
    setDrawerListArray();
  }

  void setDrawerListArray() {
    drawerList = <DrawerList>[
      DrawerList(
        index: DrawerIndex.home,
        labelName: 'Home',
        icon: const Icon(Icons.home),
      ),
      DrawerList(
        index: DrawerIndex.help,
        labelName: 'Help',
        isAssetsImage: true,
        imageName: 'assets/images/supportIcon.png',
      ),
      DrawerList(
        index: DrawerIndex.feedback,
        labelName: 'Feedback',
        icon: const Icon(Icons.help),
      ),
      DrawerList(
        index: DrawerIndex.invite,
        labelName: 'Invite Friend',
        icon: const Icon(Icons.group),
      ),
      DrawerList(
        index: DrawerIndex.about,
        labelName: 'About',
        icon: const Icon(Icons.info),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.notWhite.withOpacity(0.5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 40.0),
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  AnimatedBuilder(
                    animation: widget.iconAnimationController,
                    builder: (BuildContext context, _) {
                      return ScaleTransition(
                        scale: AlwaysStoppedAnimation<double>(
                            1.0 - (widget.iconAnimationController.value) * 0.2),
                        child: RotationTransition(
                          turns: AlwaysStoppedAnimation<double>(Tween<double>(
                                      begin: 0.0, end: 24.0)
                                  .animate(CurvedAnimation(
                                      parent: widget.iconAnimationController,
                                      curve: Curves.fastOutSlowIn))
                                  .value /
                              360),
                          child: Container(
                            height: 120,
                            width: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                    color: AppTheme.grey.withOpacity(0.6),
                                    offset: const Offset(2.0, 4.0),
                                    blurRadius: 8),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(60.0)),
                              child: ("$userPhoto" != null)
                                  ? Image.network(
                                      "$userPhoto",
                                      fit: BoxFit.fill,
                                    )
                                  : Image.asset('assets/images/userImage.png'),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8, left: 4),
                    child: ("$userDisplayname" != null)
                        ? Text(
                            "$userDisplayname",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: AppTheme.grey,
                              fontSize: 18,
                            ),
                          )
                        : Text(
                            "$userEmail",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: AppTheme.grey,
                              fontSize: 18,
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          Divider(
            height: 1,
            color: AppTheme.grey.withOpacity(0.6),
          ),
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(0.0),
              itemCount: drawerList.length,
              itemBuilder: (BuildContext context, int index) {
                return inkwell(drawerList[index]);
              },
            ),
          ),
          Divider(
            height: 1,
            color: AppTheme.grey.withOpacity(0.6),
          ),
          Column(
            children: <Widget>[
              Material(
                color: Colors.transparent,
                child: InkWell(
                  child: ListTile(
                    title: const Text(
                      'Sign Out',
                      style: TextStyle(
                        fontFamily: AppTheme.fontName,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: AppTheme.darkText,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    trailing: const Icon(
                      Icons.power_settings_new,
                      color: Colors.red,
                    ),
                    onTap: () async {
                      SharedPreferences prefs;
                      await GoogleSignIn().signOut();
                      await FirebaseAuth.instance
                          .signOut()
                          .then((value) async => {
                                prefs = await SharedPreferences.getInstance(),
                                prefs.remove('email'),
                              });

                      ///Navigator.of(context).pop(true);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => loginscreen()));
                    },
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).padding.bottom,
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget inkwell(DrawerList listData) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: Colors.grey.withOpacity(0.1),
        highlightColor: Colors.transparent,
        onTap: () {
          navigationtoScreen(listData.index);
        },
        child: Stack(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Row(
                children: <Widget>[
                  const SizedBox(
                    width: 6.0,
                    height: 46.0,
                    // decoration: BoxDecoration(
                    //   color: widget.screenIndex == listData.index
                    //       ? Colors.blue
                    //       : Colors.transparent,
                    //   borderRadius: new BorderRadius.only(
                    //     topLeft: Radius.circular(0),
                    //     topRight: Radius.circular(16),
                    //     bottomLeft: Radius.circular(0),
                    //     bottomRight: Radius.circular(16),
                    //   ),
                    // ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(4.0),
                  ),
                  if (listData.isAssetsImage)
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: Image.asset(listData.imageName,
                          color: widget.screenIndex == listData.index
                              ? Colors.blue
                              : AppTheme.nearlyBlack),
                    )
                  else
                    Icon(listData.icon?.icon,
                        color: widget.screenIndex == listData.index
                            ? Colors.blue
                            : AppTheme.nearlyBlack),
                  const Padding(
                    padding: EdgeInsets.all(4.0),
                  ),
                  Text(
                    listData.labelName,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: widget.screenIndex == listData.index
                          ? Colors.blue
                          : AppTheme.nearlyBlack,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
            if (widget.screenIndex == listData.index)
              AnimatedBuilder(
                animation: widget.iconAnimationController,
                builder: (BuildContext context, _) {
                  return Transform(
                    transform: Matrix4.translationValues(
                        (MediaQuery.of(context).size.width * 0.75 - 64) *
                            (1.0 - widget.iconAnimationController.value - 1.0),
                        0.0,
                        0.0),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 8),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.75 - 64,
                        height: 46,
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.2),
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(28),
                            bottomRight: Radius.circular(28),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              )
            else
              const SizedBox()
          ],
        ),
      ),
    );
  }

  Future<void> navigationtoScreen(DrawerIndex indexScreen) async {
    widget.callBackIndex(indexScreen);
  }
}

enum DrawerIndex { home, help, feedback, invite, about }

class DrawerList {
  DrawerList({
    @required this.index,
    this.icon,
    this.isAssetsImage = false,
    this.labelName = '',
    this.imageName = '',
  });

  String labelName;
  Icon icon;
  bool isAssetsImage;
  String imageName;
  DrawerIndex index;
}
