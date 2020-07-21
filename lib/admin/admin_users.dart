import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:safetyapp/auth/login.dart';
import 'package:safetyapp/components/progress.dart';

class AdminUsers extends StatefulWidget {

  static const String id = 'admin_users';

  @override
  _AdminUsersState createState() => _AdminUsersState();
}

class _AdminUsersState extends State<AdminUsers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: usersRef.snapshots(),
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
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 30,
                          backgroundImage: documents[index].data['photoUrl'] != '' ?  NetworkImage(documents[index].data['photoUrl']) : AssetImage('assets/images/no_image.png'),
                        ),
                        title: Text(documents[index].data['displayName']),
                        subtitle: Text(documents[index].data['email']),
                      ),
                    );
                  },
                );
              }
              else{
                return Center(
                  child: Text('No Users'),
                );
              }
            }
          },
        ),
      ),
    );
  }
}
