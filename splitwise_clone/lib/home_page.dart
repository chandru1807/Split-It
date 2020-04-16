import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import './TabPages/friends.dart';

class HomePage extends StatefulWidget {
  final String uId;
  HomePage({this.uId});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  TabController _tabCont;
  CollectionReference _userCredDb = Firestore.instance.collection('/userCred');
  @override
  void initState() {
    super.initState();
    _tabCont = new TabController(vsync: this, length: 3);
    getUserInfo();
    // WidgetsBinding.instance.addObserver(this);
    // SchedulerBinding.instance.addPostFrameCallback((val) => {
    //   print(val)
    // });
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   super.didChangeAppLifecycleState(state);
  //   if (state == AppLifecycleState.paused) {
  //     print('damn it');
  //   }
  //   if (state == AppLifecycleState.resumed) {
  //     print('yay it');
  //   }
  // }

  getUserInfo() async {
    final user = await FirebaseAuth.instance.currentUser();
    print(user);
    this._userCredDb.document(user.uid).get().then((DocumentSnapshot cred) {
      print('usercred below');
      print(cred.data);
      DocumentReference doc = cred.data['userInfo'];
      doc.get().then((DocumentSnapshot info) {
        print('userIfno below');
        print(info.data);
      });
    });
  }

  @override
  void dispose() {
    _tabCont.dispose();
    //WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white,
                    Colors.green[300],
                    Colors.green[300],
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              accountName: Text('Chandru'),
              accountEmail: Text('chandru18071995@gmail.com'),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(
                  'http://i.pravatar.cc/300',
                ),
              ),
            ),
            ListTile(
              title: Text('Settings'),
              onTap: () {},
              trailing: Icon(
                Icons.chevron_right,
              ),
            )
          ],
        ),
      ),
      appBar: this._getAppBar(),
      body: TabBarView(
        controller: _tabCont,
        children: <Widget>[
          FriendsTab(
            userId: widget.uId,
          ),
          Text('Woooo'),
          Text('Woooo'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {},
        backgroundColor: Colors.deepOrange,
        elevation: 2.0,
      ),
    );
  }

  AppBar _getAppBar() {
    return AppBar(
      actions: <Widget>[
        PopupMenuButton(
          onSelected: (value) {
            if (value == 'logout') {
              FirebaseAuth.instance.signOut();
            } else if (value == 'addFriends') {
              Navigator.of(context).pushNamed('/addFriends');
            }
          },
          icon: Icon(Icons.more_vert),
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'logout',
              child: Text('Logout'),
            ),
            const PopupMenuItem(
              value: 'addFriends',
              child: Text('Add Friends'),
            ),
          ],
        )
      ],
      title: Text(
        'SplitWise Clone',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.green[300],
      centerTitle: true,
      bottom: TabBar(
        indicatorColor: Colors.white,
        indicatorWeight: 2.5,
        controller: _tabCont,
        tabs: <Widget>[
          Tab(
            child: Text('FRIENDS'),
          ),
          Tab(
            child: Text('GROUPS'),
          ),
          Tab(
            child: Text('ACTIVITY'),
          )
        ],
      ),
    );
  }
}
