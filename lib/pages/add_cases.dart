import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:safetyapp/auth/login.dart';
import 'package:safetyapp/components/progress.dart';
import 'package:safetyapp/components/rounded_button.dart';
import 'package:safetyapp/constants.dart';
import 'package:safetyapp/model/user.dart';
import 'package:uuid/uuid.dart';

class AddCases extends StatefulWidget {

  static const String id = 'add_cases';

  AddCases({@required this.currentUserId});
  final currentUserId;


  @override
  _AddCasesState createState() => _AddCasesState();
}

class _AddCasesState extends State<AddCases> {

  final formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController detailsController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  bool titleValid = true;
  bool detailsValid = true;
  bool phoneNumberValid = true;
  bool addressValid = true;
  bool isLoading = false;
  User user;
  bool showSpinner = false;
  String caseId = Uuid().v4();
  final scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  void initState() {
    super.initState();
    getUser();
    print(widget.currentUserId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: isLoading ? circularProgress() : ModalProgressHUD(
        color: kGreenColor,
        inAsyncCall: showSpinner,
        child: Column(
          children: <Widget>[
            Expanded(
              child: Align(
                alignment: Alignment.topLeft,
                child: Image.asset('assets/images/top_shape.png'),
              ),
            ),

            Expanded(
              flex: 4,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                child: Form(
                  key: formKey,
                  child: ListView(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(bottom: 20.0),
                        child: Text('ادخل التفاصيل التالية', style: TextStyle(fontSize: 40,
                            color: kGreenColor, fontWeight: FontWeight.bold), textAlign: TextAlign.center,
                        ),
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: buildInputs() + buildSubmitButtons(),
                      ),

                    ],
                  ),
                ),
              ),
            ),

            Expanded(
              child: Align(
                alignment: Alignment.bottomRight,
                child: Image.asset('assets/images/bottom_shape.png'),
              ),
            ),

          ],
        ),
      ),
    );
  }

  getUser() async {
    setState(() {
      isLoading = true;
    });
    DocumentSnapshot doc = await usersRef.document(widget.currentUserId).get();
    user = User.fromDocument(doc);

    setState(() {
      isLoading = false;
    });
  }

  List<Widget> buildInputs(){
    return [
      Directionality(
        textDirection: TextDirection.rtl,
        child: TextFormField(
          textAlign: TextAlign.right,
          controller: titleController,
          keyboardType: TextInputType.emailAddress,
          decoration: kTextFieldDecoration.copyWith(
              hintText: 'ادخل عنوان الحالة هنا',
              labelText: 'عنوان الحالة',
              errorText: titleValid ? null : 'يجب ان يكون العنوان ما بين 5 الى 15 حرف'
          ),
          style: TextStyle(
              height: 0.7,
              color: kGreenColor
          ),
        ),
      ),

      SizedBox(height: 15.0,),

      Directionality(
        textDirection: TextDirection.rtl,
        child: TextFormField(
          maxLines: 2,
          textAlign: TextAlign.right,
          controller: detailsController,
          keyboardType: TextInputType.emailAddress,
          decoration: kTextFieldDecoration.copyWith(
              hintText: 'ادخل تفاصيل الحالة هنا',
              labelText: 'تفاصيل الحالة',
              errorText: detailsValid ? null : 'يجب ان تكون التفاصيل ما بين 10 الى 50 حرف'
          ),
          style: TextStyle(
              height: 0.7,
              color: kGreenColor
          ),
        ),
      ),

      SizedBox(height: 15.0,),

      Directionality(
        textDirection: TextDirection.rtl,
        child: TextFormField(
          textAlign: TextAlign.right,
          controller: phoneNumberController,
          keyboardType: TextInputType.number,
          decoration: kTextFieldDecoration.copyWith(
              hintText: 'ادخل رقم الموبايل هنا',
              labelText: 'رقم الموبايل',
              errorText: phoneNumberValid ? null : 'يرجى ادخال رقم الموبايل بشكل صحيح'
          ),
          style: TextStyle(
              height: 0.7,
              color: kGreenColor
          ),
        ),
      ),

      SizedBox(height: 15.0,),

      Directionality(
        textDirection: TextDirection.rtl,
        child: TextFormField(
          textAlign: TextAlign.right,
          controller: addressController,
          keyboardType: TextInputType.emailAddress,
          decoration: kTextFieldDecoration.copyWith(
              hintText: 'ادخل عنوانك مع اقرب نقطة دالة',
              labelText: 'العنوان',
              errorText: addressValid ? null : 'يجب ان يكون العنوان ما بين 10 الى 30 حرف'
          ),
          style: TextStyle(
              height: 0.7,
              color: kGreenColor
          ),
        ),
      ),
    ];
  }

  List<Widget> buildSubmitButtons (){
    return [
      Padding(
        padding: EdgeInsets.only(top: 10.0),
        child: RoundedButton(
          title: 'اضافة الحالة',
          colour: kGreenColor,
          onPressed: validateAndSubmit,
        ),
      ),
    ];
  }

  validateAndSubmit() async {
    setState(() {
      titleController.text.trim().length < 5 ||
      titleController.text.trim().length > 15 ? titleValid = false : titleValid = true;

      detailsController.text.trim().length < 10 ||
      detailsController.text.trim().length > 50 ? detailsValid = false : detailsValid = true;

      phoneNumberController.text.trim().length < 11 ||
      phoneNumberController.text.trim().length > 11 ? phoneNumberValid = false : phoneNumberValid = true;

      addressController.text.trim().length < 10 ||
      addressController.text.trim().length > 30 ? addressValid = false : addressValid = true;
    });

    if(user.latitude != '' && user.longitude != ''){
      if(titleValid && detailsValid && phoneNumberValid && addressValid){
        await updatePhoneNumber();
        await createCasesInFirestore();
        Timer(Duration(seconds: 2),(){
          Navigator.pop(context);
        });
      }
    }
    else{
      getCurrentLocation();
    }

  }

  Future<void> getCurrentLocation() async {
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    if(position.latitude != null && position.longitude != null){
      await usersRef.document(widget.currentUserId).updateData({
        'latitude' : position.latitude.toString(),
        'longitude' : position.longitude.toString()
      }).then((value) {
        getUser();
      });
    }
  }

  updatePhoneNumber() async {
    await usersRef.document(widget.currentUserId).updateData({
      'phoneNumber' : phoneNumberController.text,
    });
  }


  createCasesInFirestore() async {
    setState(() {
      showSpinner = true;
    });
    await adminRef.document(widget.currentUserId).setData({
      'title' : titleController.text,
      'details' : detailsController.text,
      'phoneNumber' : phoneNumberController.text,
      'address' : addressController.text,
      'caseId' : caseId,
      'latitude' : user.latitude,
      'longitude' : user.longitude,
      'displayName' : user.displayName,
      'photoUrl' : user.photoUrl,
      'userId' : user.userId,
      'tokenMessage' : user.tokenMessage,
    }).then((value){
      setState(() {
        showSpinner = false;
      });

      SnackBar snackBar = SnackBar(content: Text('تم ارسال الحالة يرجى الانتظار للموافقة', textAlign: TextAlign.center,),);
      scaffoldKey.currentState.showSnackBar(snackBar);

//      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => CaseSendingToRequestPage()), (
//          Route<dynamic> route) => false);


    });
  }


//  createCasesInFirestore() async {
//    setState(() {
//      showSpinner = true;
//    });
//    await adminRef.document(widget.currentUserId).collection('userCases').document(caseId).setData({
//      'title' : titleController.text,
//      'details' : detailsController.text,
//      'phoneNumber' : phoneNumberController.text,
//      'address' : addressController.text,
//      'caseId' : caseId,
//      'latitude' : user.latitude,
//      'longitude' : user.longitude,
//      'displayName' : user.displayName,
//      'photoUrl' : user.photoUrl,
//      'userId' : user.userId,
//      'tokenMessage' : user.tokenMessage,
//    }).then((value){
//      setState(() {
//        showSpinner = false;
//      });
//
//      SnackBar snackBar = SnackBar(content: Text('تم ارسال الحالة يرجى الانتظار للموافقة', textAlign: TextAlign.center,),);
//      scaffoldKey.currentState.showSnackBar(snackBar);
//
////      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => CaseSendingToRequestPage()), (
////          Route<dynamic> route) => false);
//
//
//    });
//  }

}
