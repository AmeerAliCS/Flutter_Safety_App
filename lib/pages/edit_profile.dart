import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:safetyapp/auth/login.dart';
import 'package:safetyapp/components/progress.dart';
import 'package:safetyapp/components/rounded_button.dart';
import 'package:safetyapp/constants.dart';
import 'package:safetyapp/model/user.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class EditProfile extends StatefulWidget {

  static const String id = 'edit_profile';

  EditProfile({@required this.profileId});
  final profileId;

  @override
  _EditProfileState createState() => _EditProfileState();
}


class _EditProfileState extends State<EditProfile> {

  TextEditingController displayNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = false;
  User user;
  bool _displayNameValid = true;
  bool _phoneNumberValid = true;
  File image;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    getUser();
    print(widget.profileId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF1F1F1),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: kGreenColor,),
          onPressed: (){
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Color(0xffF1F1F1),
        centerTitle: true,
        elevation: 0.0,
      ),
      key: scaffoldKey,
      body: isLoading ? circularProgress() : ListView(
          children: <Widget>[
            Column(
              children: <Widget>[

                Padding(
                  padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0, bottom: 20.0),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 20.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    width: double.infinity,
                    child: Padding(
                      padding: EdgeInsets.only(top: 16.0 , bottom: 8.0),
                      child: Column(
                        children: <Widget>[
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 50.0,
                            backgroundImage: (image != null) ? FileImage(image)
                            : (user.photoUrl != '') ? NetworkImage(user.photoUrl) : AssetImage('assets/images/no_image.png'),
                          ),

                          InkWell(
                            child: Text('تغيير الصورة الشخصية',
                              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: kGreenColor),),
                            onTap: getImage,
                          ),

                        ],
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    width: double.infinity,
                    child: Padding(
                      padding: EdgeInsets.all(30.0),
                      child: Column(
                        children: <Widget>[
                          buildDisplayNameField(),
                          buildPhoneNumberField(),
                          SizedBox(height: 15.0),
                          RoundedButton(
                            colour: kGreenColor,
                            title: 'حفظ المعلومات',
                            onPressed: (){
                              updateProfileData(context);
                              Timer(Duration(seconds: 2),(){
                                Navigator.pop(context);
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              ],
            ),
          ]
      )

    );
  }


  getUser() async {
    setState(() {
      isLoading = true;
    });
    DocumentSnapshot doc = await usersRef.document(widget.profileId).get();
    user = User.fromDocument(doc);
    displayNameController.text = user.displayName;
    phoneNumberController.text = user.phoneNumber;
    setState(() {
      isLoading = false;
    });
  }

  Column buildDisplayNameField(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 12.0, bottom: 10.0, right: 5.0),
          child: Align(
              alignment: Alignment.centerRight,
              child: Text('الاسم', style: TextStyle(color: Colors.grey))
          ),
        ),

        TextField(
            textAlign: TextAlign.right,
            style: TextStyle(
                height: 0.7,
                color: kGreenColor
            ),
          controller: displayNameController,
          decoration: kTextFieldDecoration.copyWith(
            hintText: 'تحديث الاسم',
            errorText: _displayNameValid ? null : "Display Name too short",
          )
        )

      ],
    );
  }

  Column buildPhoneNumberField(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 12.0, bottom: 10.0, right: 5.0),
          child: Align(
              alignment: Alignment.centerRight,
              child: Text('رقم الموبايل', style: TextStyle(color: Colors.grey))
          ),
        ),

        TextField(
            textAlign: TextAlign.right,
            style: TextStyle(
                height: 0.7,
                color: kGreenColor
            ),
            keyboardType: TextInputType.number,
            controller: phoneNumberController,
            decoration: kTextFieldDecoration.copyWith(
              hintText: 'تحديث رقم الهاتف',
              errorText: _displayNameValid ? null : "number too long",
            )
        )
      ],
    );
  }

  updateProfileData(BuildContext context){
    setState(() {
      displayNameController.text.trim().length < 3 ||
          displayNameController.text.isEmpty ||
          displayNameController.text.length > 30 ? _displayNameValid = false : _displayNameValid = true;

      phoneNumberController.text.trim().length > 11
          ? _phoneNumberValid = false : _phoneNumberValid = true;

    });

    uploadImage(context);

    if(_displayNameValid || _phoneNumberValid){
      usersRef.document(widget.profileId).updateData({
        'displayName' : displayNameController.text,
        'phoneNumber' : phoneNumberController.text
      });
      SnackBar snackBar = SnackBar(content: Text('تم تحديث المعلومات', textAlign: TextAlign.center,),);
      scaffoldKey.currentState.showSnackBar(snackBar);
    }
  }

  Future getImage() async {
//    final myImage = await picker.getImage(source: ImageSource.gallery);
      PickedFile compressedImage = await picker.getImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    setState(() {
      image = File(compressedImage.path);
    });
  }

  Future uploadImage(BuildContext context) async {
      StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child('image_${user.userId}.jpg');
      StorageUploadTask uploadTask = firebaseStorageRef.putFile(image);
      StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
      String photoUrl = await taskSnapshot.ref.getDownloadURL();
      usersRef.document(widget.profileId).updateData({
        'photoUrl' : photoUrl,
      });
  }


}
