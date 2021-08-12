import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/Constants.dart';
import 'package:flutter_app/app_theme.dart';
import 'package:flutter_app/main2.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:io' as i;

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with TickerProviderStateMixin {
  AnimationController _animationController;

  double _containerPaddingLeft = 20.0;
  double _animationValue;
  double _translateX = 0;
  double _translateY = 0;
  double _rotate = 0;
  double _scale = 1;

  bool show;
  bool sent = false;
  Color _color = Colors.blueAccent;
  DateTime datetime;
  List gender_option = ['Male', 'Female', 'Transgender', 'Perefer Not to Say'];

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  User user;
  // ignore: unused_field
  String _email,
      _userid,
      _fullName,
      _address,
      _gender,
      _dob,
      _username,
      _mobno,
      _room_doc_id;
  var _profile_id;

  PickedFile _image;
  GlobalKey<FormState> profileBuildingFormkey = GlobalKey<FormState>();

  @override
  void initState() {
    user = _auth.currentUser;
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1300));
    show = true;
    _animationController.addListener(() {
      setState(() {
        show = false;
        _animationValue = _animationController.value;
        if (_animationValue >= 0.2 && _animationValue < 0.4) {
          _containerPaddingLeft = 100.0;
          _color = Colors.green;
        } else if (_animationValue >= 0.4 && _animationValue <= 0.5) {
          _translateX = 80.0;
          _rotate = -20.0;
          _scale = 0.1;
        } else if (_animationValue >= 0.5 && _animationValue <= 0.8) {
          _translateY = -20.0;
        } else if (_animationValue >= 0.81) {
          _containerPaddingLeft = 20.0;
          sent = true;
        }
      });
      print(_translateX);
    });
  }

  Future<void> submitdata() async {
    if (profileBuildingFormkey.currentState.validate()) {
      profileBuildingFormkey.currentState.save();

      await upload_image();

      var x = user.uid;
      await user.updateProfile(displayName: _username, photoURL: _profile_id);

      CollectionReference col = db.collection('/Users');
      Future<void> adduser() {
        _email = user.email;
        return col.doc('$x').set({
          'userid': '$x',
          'Username': '$_username',
          'Fullname': '$_fullName',
          'Mobno': '$_mobno',
          'Email': '$_email',
          'Address': '$_address',
          'Gender': '$_gender',
          'Dob': '$_dob',
          'Room_doc_id': 'null',
          'Profile_Photo_Url': '$_profile_id',
        });
      }

      ScaffoldMessenger.of(this.context)
          .showSnackBar(SnackBar(content: Text('Successfully added.......')));

      await adduser().whenComplete(() => Navigator.pushReplacement(
          this.context, MaterialPageRoute(builder: (context) => ThisApp())));
    }
  }

  Future upload_image() async {
    if (_image == null) {
      _image =
          await ImagePicker.platform.pickImage(source: ImageSource.gallery);
    }

    var file = i.File(_image.path);
    String imagename = DateTime.now().toString();
    if (_image != null) {
      //Upload to Firebase
      var snapshot = await firebase_storage.FirebaseStorage.instance
          .ref()
          .child('/Userphoto/$imagename')
          .putFile(file);

      var downloadUrl = await snapshot.ref.getDownloadURL();
      setState(() {
        _profile_id = downloadUrl;
      });
    } else {
      ScaffoldMessenger.of(this.context)
          .showSnackBar(SnackBar(content: Text('Image is not choosen.......')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      body: SafeArea(
          child: Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            title: Text(
              "Profile SetUp",
              style: AppTheme.textTheme.headline5,
            ),
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: AppTheme.darkBlue,
              ),
              tooltip: "go back",
              visualDensity: VisualDensity(),
              splashColor: Colors.blueAccent,
              onPressed: () {
                Navigator.pop(context);
              },
            )),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 10, bottom: 30),
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    getImage();
                  },
                  child: Container(
                    height: 130,
                    width: 130,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            color: AppTheme.grey,
                            offset: const Offset(2.0, 4.0),
                            blurRadius: 50),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(80.0)),
                      child: (_image != null)
                          ? Image.file(
                              i.File(_image.path),
                              fit: BoxFit.fill,
                            )
                          : Image.asset('assets/images/userImage.png'),
                    ),
                  ),
                ),
              ),
            ),
            Form(
              key: profileBuildingFormkey,
              child: Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    textField(
                      callback: (value) {
                        setState(() {
                          _username = value;
                        });
                      },
                      hintText: 'UserName',
                      padding: 15.0,
                      icon: Icon(
                        Icons.edit,
                        color: AppTheme.darkBlue,
                        size: 20,
                      ),
                      type: TextInputType.text,
                    ),
                    textField(
                      callback: (value) {
                        setState(() {
                          _fullName = value;
                        });
                      },
                      hintText: 'FullName',
                      padding: 15.0,
                      icon: Icon(
                        Icons.verified_user_rounded,
                        color: AppTheme.darkBlue,
                        size: 20,
                      ),
                      type: TextInputType.text,
                    ),
                    textField(
                      callback: (value) {
                        setState(() {
                          _mobno = value;
                        });
                      },
                      hintText: 'Mobile Number',
                      padding: 15.0,
                      icon: Icon(
                        Icons.phone,
                        color: AppTheme.darkBlue,
                        size: 20,
                      ),
                      type: TextInputType.number,
                    ),
                    textField(
                      callback: (value) {
                        setState(() {
                          _address = value;
                        });
                      },
                      hintText: 'Address',
                      padding: 15.0,
                      icon: Icon(
                        Icons.location_city_sharp,
                        color: AppTheme.darkBlue,
                        size: 20,
                      ),
                      type: TextInputType.text,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 15),
                      child: FlatButton(
                        color: AppTheme.white,
                        onPressed: () {
                          showDatePicker(
                                  context: context,
                                  initialDate: (datetime == null)
                                      ? DateTime.now()
                                      : datetime,
                                  firstDate: DateTime(1950),
                                  lastDate: DateTime(2022))
                              .then((date) {
                            setState(() {
                              datetime = date;
                              if (datetime.isBefore(DateTime.now())) {
                                _dob =
                                    DateFormat('dd-MM-yyyy').format(datetime);
                              } else {
                                _dob = DateFormat('dd-MM-yyyy')
                                    .format(DateTime.now());

                                ScaffoldMessenger.of(this.context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            'Your date selection is wrong....')));
                              }
                            });
                          });
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.date_range,
                              color: AppTheme.darkBlue,
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Container(
                                width: MediaQuery.of(context).size.width - 71,
                                decoration: BoxDecoration(
                                    color: AppTheme.darkBlue,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(25))),
                                child: Padding(
                                    padding: EdgeInsets.all(15),
                                    child: Text(
                                      (datetime == null)
                                          ? 'Select Your BirthDate'
                                          : _dob,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ))),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 15),
                      child: Padding(
                        padding: EdgeInsets.all(15),
                        child: Row(
                          children: [
                            Icon(
                              Icons.person,
                              color: AppTheme.darkBlue,
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width - 71,
                              decoration: BoxDecoration(
                                  color: AppTheme.darkBlue,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(25))),
                              child: Padding(
                                padding: EdgeInsets.only(left: 15),
                                child: DropdownButton(
                                  hint: (_gender != null)
                                      ? Text(
                                          _gender.toString(),
                                        )
                                      : Text(
                                          "Select",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                  dropdownColor: Colors.blueAccent,
                                  icon: Icon(
                                    Icons.arrow_drop_down,
                                    color: AppTheme.white,
                                  ),
                                  iconSize: 50,
                                  isExpanded: true,
                                  underline: SizedBox(),
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  value: _gender,
                                  onChanged: (newvalue) {
                                    setState(() {
                                      _gender = newvalue;
                                    });
                                  },
                                  items: gender_option.map((e) {
                                    return DropdownMenuItem(
                                      value: e,
                                      child: Text(e),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Center(
                          child: GestureDetector(
                              onTap: () {
                                _animationController.forward();
                                Future.delayed(Duration(seconds: 2), () async {
                                  await submitdata();
                                  // await submitdata();
                                });
                              },
                              child: AnimatedContainer(
                                  decoration: BoxDecoration(
                                    color: _color,
                                    borderRadius: BorderRadius.circular(100.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: _color,
                                        blurRadius: 21, // soften the shadow
                                        spreadRadius: -15, //end the shadow
                                        offset: Offset(
                                          0.0, // Move to right 10  horizontally
                                          20.0, // Move to bottom 10 Vertically
                                        ),
                                      )
                                    ],
                                  ),
                                  padding: EdgeInsets.only(
                                      left: _containerPaddingLeft,
                                      right: 20.0,
                                      top: 10.0,
                                      bottom: 10.0),
                                  duration: Duration(milliseconds: 400),
                                  curve: Curves.easeOutCubic,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      (!sent)
                                          ? AnimatedContainer(
                                              duration:
                                                  Duration(milliseconds: 400),
                                              child: Icon(
                                                Icons.cloud_upload,
                                                color: AppTheme.white,
                                              ),
                                              curve: Curves.fastOutSlowIn,
                                              transform:
                                                  Matrix4.translationValues(
                                                      _translateX,
                                                      _translateY,
                                                      0)
                                                    ..rotateZ(_rotate)
                                                    ..scale(_scale),
                                            )
                                          : Container(),
                                      AnimatedSize(
                                        vsync: this,
                                        duration: Duration(milliseconds: 600),
                                        child: show
                                            ? SizedBox(width: 10.0)
                                            : Container(),
                                      ),
                                      AnimatedSize(
                                        vsync: this,
                                        duration: Duration(milliseconds: 200),
                                        child: show
                                            ? Text(
                                                "Upload",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              )
                                            : Container(),
                                      ),
                                      AnimatedSize(
                                        vsync: this,
                                        duration: Duration(milliseconds: 200),
                                        child: sent
                                            ? Icon(
                                                Icons.done,
                                                color: AppTheme.white,
                                              )
                                            : Container(),
                                      ),
                                      AnimatedSize(
                                        vsync: this,
                                        alignment: Alignment.topLeft,
                                        duration: Duration(milliseconds: 600),
                                        child: sent
                                            ? SizedBox(width: 10.0)
                                            : Container(),
                                      ),
                                      AnimatedSize(
                                        vsync: this,
                                        duration: Duration(milliseconds: 200),
                                        child: sent
                                            ? Text(
                                                "Wait",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              )
                                            : Container(),
                                      ),
                                    ],
                                  )))),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      )),
    );
  }

  Future getImage() async {
    var image =
        await ImagePicker.platform.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
      print('Image Path $_image');
    });
  }
}

class textField extends StatelessWidget {
  final String hintText;
  final Icon icon;
  final padding;
  final TextInputType type;
  final Function callback;

  textField(
      {@required this.hintText,
      this.icon,
      this.padding,
      this.type,
      this.callback});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: TextFormField(
        keyboardType: type,
        validator: commonValidation,
        style: TextStyle(
          fontSize: 16,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        cursorColor: AppTheme.white,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(
                width: 0, style: BorderStyle.solid, color: Colors.black),
          ),
          icon: icon,
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(
              width: 0,
              style: BorderStyle.none,
            ),
          ),
          filled: true,
          fillColor: Colors.blueAccent,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        ),
        onChanged: callback,
      ),
    );
  }
}
