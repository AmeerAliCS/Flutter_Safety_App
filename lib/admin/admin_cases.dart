import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:safetyapp/admin/admin_cases_details.dart';
import 'package:safetyapp/auth/login.dart';
import 'package:safetyapp/components/progress.dart';
import 'package:safetyapp/constants.dart';
import 'package:safetyapp/services/messaging.dart';

class AdminCases extends StatefulWidget {

  static const String id = 'admin_cases';

  @override
  _AdminCasesState createState() => _AdminCasesState();
}

class _AdminCasesState extends State<AdminCases> {

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: adminRef.snapshots(),
          builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot){
            if (snapshot.hasError){
              return new Center(
                  child:Text('Error: ${snapshot.error}')
              );
            }
            if(!snapshot.hasData){
              return new Center(
                  child:circularProgress()
              );
            }

            else{
              var documents = snapshot.data.documents;
              if(documents.length>0){
                return ListView.builder(
                  itemCount: documents.length,
                  itemBuilder: (context, index){
                    return Card(
                      child: GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => AdminCasesDetails(
                            title: documents[index].data['title'],
                            details: documents[index].data['details'],
                            phoneNumber: documents[index].data['phoneNumber'],
                            address: documents[index].data['address'],
                          )));
                        },
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 30,
                            backgroundImage: documents[index].data['photoUrl'] != '' ?  NetworkImage(documents[index].data['photoUrl']) : AssetImage('assets/images/no_image.png'),
                          ),
                          title: Text(documents[index].data['title']),
                          subtitle: Text(documents[index].data['details']),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              IconButton(
                                icon: Icon(Icons.check, color: kGreenColor),
                                onPressed: (){
                                  casesRef.document(documents[index].data['userId']).setData({
                                  'title' : documents[index].data['title'],
                                  'details' : documents[index].data['details'],
                                  'phoneNumber' : documents[index].data['phoneNumber'],
                                  'address' : documents[index].data['address'],
                                  'caseId' : documents[index].data['caseId'],
                                  'latitude' : documents[index].data['latitude'],
                                  'longitude' : documents[index].data['longitude'],
                                  'displayName' : documents[index].data['displayName'],
                                  'photoUrl' : documents[index].data['photoUrl'],
                                  'userId' : documents[index].data['userId'],
                                  'tokenMessage' : documents[index].data['tokenMessage'],
                                  }).then((value){
                                    sendNotification();
                                    print("Added successfully");
                                  });

                                  adminRef.document(documents[index].documentID).delete().then((value){
                                    print("Deleted successfully");
                                  });

                                },
                              ),

                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: (){
                                  adminRef.document(documents[index].documentID).delete().then((value){
                                    print("Deleted successfully");
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
              else{
                return Center(
                  child: Text('No Cases'),
                );
              }
            }
          }
        ),
      ),
    );

  }





  Future sendNotification() async {
    final response = await Messaging.sendToAll(
      title: 'تمت اضافة حالة جديدة',
      body: 'يرجى فتح التطبيق لرؤية الحالة الجديدة',
      // fcmToken: fcmToken,
    );

    if (response.statusCode != 200) {
      print('Error Message');
    }
  }

}
