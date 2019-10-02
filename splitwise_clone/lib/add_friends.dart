import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:permission/permission.dart';

class AddFriends extends StatefulWidget {
  @override
  _AddFriendsState createState() => _AddFriendsState();
}

class _AddFriendsState extends State<AddFriends> {
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
    return contacts;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[300],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: null,
        elevation: 2.0,
        child: Icon(Icons.chevron_right),
        backgroundColor: Colors.deepOrange,
      ),
      body: FutureBuilder(
          future: _getPermission(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.none ||
                snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              return FutureBuilder(
                future: getContacts(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.none ||
                      snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    Iterable<Contact> allContacts = snapshot.data;
                    return ListView.builder(
                      itemCount: allContacts.length,
                      itemBuilder: (context, index) {
                        var contact = allContacts.elementAt(index);
                        return ListTile(
                          trailing: Icon(Icons.add),
                          leading: contact.avatar.isEmpty
                              ? CircleAvatar(
                                  child: Text((contact.displayName != null &&
                                          contact.displayName.length >= 2)
                                      ? contact.displayName[0] +
                                          contact.displayName[1]
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
                },
              );
            }
          }),
    );
  }
}
