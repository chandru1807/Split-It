import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FriendsTab extends StatefulWidget {
  final String userId;
  FriendsTab({this.userId});
  _FriendsTabState createState() => _FriendsTabState();
}

class _FriendsTabState extends State<FriendsTab> {
  CollectionReference db = Firestore.instance.collection('friends');
  Map addition = {'name': 'Chandru', 'age': 23};
  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder(
          stream: db.snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshots) {
            if (!snapshots.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.orange[300],
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                ),
              );
            } else {
              if (snapshots.data.documents.length > 0) {
                return Text(snapshots.data.documents[0]['name']);
              } else {
                return Text('No friends man!! Get some friends ffs!');
              }
            }
          }),
    );
  }
}
