import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:permission/permission.dart';

class AddFriends extends StatefulWidget {
  @override
  _AddFriendsState createState() => _AddFriendsState();
}

class _AddFriendsState extends State<AddFriends> {
  Iterable<Contact> contacts;
  Iterable<Contact> originalContacts;
  List<Contact> selectedContacts = [];
  bool _isSearchOn = false;
  _getPermission() async {
    List<Permissions> permission =
        await Permission.getPermissionsStatus([PermissionName.Contacts]);

    if (permission[0].permissionStatus != PermissionStatus.allow) {
      List<Permissions> getPermission =
          await Permission.requestPermissions([PermissionName.Contacts]);
      if (getPermission[0].permissionStatus != PermissionStatus.allow) {
        Navigator.of(context).pop();
      } else {
        return getPermission;
      }
    }
    return permission;
  }

  getContacts() async {
    Iterable<Contact> contacts = await ContactsService.getContacts();
    if (contacts.isEmpty) {
      Navigator.of(context).pop();
    }
    this.contacts = contacts;
    this.originalContacts = contacts;
    return contacts;
  }

  filterContacts(String typedVal) {
    this.contacts = this.originalContacts.where((Contact contact) =>
        contact.displayName.contains(typedVal) ||
        contact.phones.any((Item num) => num.value.contains(typedVal)));

    this.setState(() => this.contacts);
  }

  Widget getFilterContactsWidget(isSearchOn) {
    print(isSearchOn);
    if (isSearchOn) {
      return Container(
        key: ValueKey(1),
        width: MediaQuery.of(context).size.width - 50,
        padding: this._isSearchOn
            ? null
            : EdgeInsets.only(left: MediaQuery.of(context).size.width - 100),
        child: TextFormField(
          autofocus: true,
          decoration: InputDecoration(
            enabledBorder: InputBorder.none,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(20.0),
              ),
              borderSide: BorderSide(
                color: Colors.white,
              ),
            ),
            hasFloatingPlaceholder: true,
            suffixIcon: IconButton(
              color: Colors.white,
              icon: Icon(Icons.cancel),
              onPressed: () => this.setState(() => {
                    this._isSearchOn = false,
                    this.contacts = this.originalContacts
                  }),
            ),
            isDense: true,
            hintText: 'Search by name or number',
            hintStyle: TextStyle(
              fontStyle: FontStyle.italic,
              color: Colors.white,
            ),
          ),
          onChanged: (String typedVal) => {this.filterContacts(typedVal)},
        ),
      );
    } else {
      return Container(
        key: ValueKey(2),
        width: MediaQuery.of(context).size.width - 50,
        padding: this._isSearchOn
            ? null
            : EdgeInsets.only(left: MediaQuery.of(context).size.width - 100),
        child: IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () => {
                  this.setState(() {
                    this._isSearchOn = true;
                  })
                }),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[300],
        actions: <Widget>[
          AnimatedSwitcher(
            duration: Duration(milliseconds: 500),
            child: getFilterContactsWidget(this._isSearchOn),
          )
        ],
      ),
      floatingActionButton:
          FloatingAddFriends(selectedContacts: selectedContacts),
      body: this.contacts != null
          ? buildContactView(this.contacts)
          : FutureBuilder(
              future: _getPermission(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.none ||
                    snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasData &&
                    (snapshot.data.elementAt(0).permissionStatus ==
                            PermissionStatus.notAgain ||
                        snapshot.data.elementAt(0).permissionStatus ==
                            PermissionStatus.deny)) {
                  return Container(
                    child: Column(
                      children: <Widget>[
                        Text(
                            "Need permission to access contacts. Press button below to grant access :)"),
                        RaisedButton(onPressed: this._getPermission),
                      ],
                    ),
                  );
                } else {
                  return FutureBuilder(
                    future: getContacts(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.none ||
                          snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else {
                        Iterable<Contact> allContacts = snapshot.data;
                        return buildContactView(allContacts);
                      }
                    },
                  );
                }
              }),
    );
  }

  ListView buildContactView(Iterable<Contact> allContacts) {
    return ListView.builder(
      itemCount: allContacts.length,
      itemBuilder: (context, index) {
        var contact = allContacts.elementAt(index);
        return ListTile(
          trailing: IconButton(
            key: ValueKey('icBtn' + index.toString()),
            icon: AnimatedSwitcher(
              key: ValueKey(index),
              duration: Duration(milliseconds: 500),
              child: this.selectedContacts.any((Contact selContact) =>
                      selContact.displayName == contact.displayName)
                  ? Icon(
                      Icons.check_circle,
                      size: 30,
                      color: Colors.green[300],
                      key: ValueKey('check' + index.toString()),
                    )
                  : Icon(
                      Icons.add_circle,
                      size: 30,
                      color: Colors.blueAccent,
                      key: ValueKey('add' + index.toString()),
                    ),
            ),
            onPressed: () {
              if (this.selectedContacts.any((Contact selContact) =>
                  selContact.displayName == contact.displayName)) {
                //this.selectedContacts = this.selectedContacts.skipWhile((Contact c) => c.displayName != contact.displayName).toList();
                this.selectedContacts.removeAt(this.selectedContacts.indexWhere(
                    (Contact c) => c.displayName == contact.displayName));
                this.setState(() => {
                      this.selectedContacts,
                    });
              } else {
                this.setState(() => {
                      this.selectedContacts = [
                        ...this.selectedContacts,
                        contact
                      ],
                    });
              }
            },
          ),
          leading: contact.avatar.isEmpty
              ? CircleAvatar(
                  child: Text((contact.displayName != null &&
                          contact.displayName.length >= 2)
                      ? contact.displayName[0] + contact.displayName[1]
                      : 'OOPS'),
                )
              : CircleAvatar(
                  backgroundImage: MemoryImage(contact.avatar),
                ),
          title: Text(contact.displayName ?? 'No name'),
          subtitle: Text(contact.phones.isNotEmpty
              ? contact.phones.first.value
              : 'No Number'),
        );
      },
    );
  }
}

class FloatingAddFriends extends StatelessWidget {
  const FloatingAddFriends({
    Key key,
    @required this.selectedContacts,
  }) : super(key: key);

  final List<Contact> selectedContacts;
  showSnack(BuildContext context) {
    SnackBar sn = SnackBar(
      content: Text('Successfully added friends!'),
    );
    Scaffold.of(context).showSnackBar(sn);
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      foregroundColor:
          this.selectedContacts.isNotEmpty ? Colors.white : Colors.grey,
      onPressed:
          this.selectedContacts.isNotEmpty ? () => showSnack(context) : null,
      elevation: 2.0,
      child: this.selectedContacts.isNotEmpty
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(this.selectedContacts.length.toString()),
                Icon(
                  Icons.chevron_right,
                ),
              ],
            )
          : Icon(
              Icons.chevron_right,
            ),
      backgroundColor:
          this.selectedContacts.isNotEmpty ? Colors.orange : Colors.blueGrey,
    );
  }
}
