import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  TabController _tabCont;

  @override
  void initState() {
    super.initState();
    _tabCont = new TabController(vsync: this, length: 3);
  }

  @override
  void dispose() {
    _tabCont.dispose();
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
      appBar: AppBar(
        title: Text(
          'SplitWise Clone',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.green[300],
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
            onPressed: () {},
            splashColor: Colors.white,
          )
        ],
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
      ),
      body: TabBarView(
        controller: _tabCont,
        children: <Widget>[
          Text('Woooo'),
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
}
