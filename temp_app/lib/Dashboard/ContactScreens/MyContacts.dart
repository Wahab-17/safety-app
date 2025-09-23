import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyContactsScreen extends StatefulWidget {
  const MyContactsScreen({Key? key}) : super(key: key);

  @override
  _MyContactsScreenState createState() => _MyContactsScreenState();
}

class _MyContactsScreenState extends State<MyContactsScreen> {
  List<String> _contacts = const <String>[];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFAFCFE),
      appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          title: Text(
            "SOS Contacts",
            style: TextStyle(
                fontSize: 26, fontWeight: FontWeight.w900, color: Colors.black),
          ),
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: Image.asset("assets/phone_red.png"),
            onPressed: () {},
          )),
      body: FutureBuilder(
          future: checkforContacts(),
          builder: (context, AsyncSnapshot<List<String>> snap) {
            if (snap.hasData && (snap.data?.isNotEmpty ?? false)) {
              _contacts = snap.data!;
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Divider(
                            indent: 20,
                            endIndent: 20,
                          ),
                        ),
                        Text("Swipe left to delete Contact"),
                        Expanded(
                          child: Divider(
                            indent: 20,
                            endIndent: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _contacts.length,
                      itemBuilder: (context, index) {
                        return Slidable(
                          endActionPane: ActionPane(
                            motion: const DrawerMotion(),
                            extentRatio: 0.25,
                            children: <Widget>[
                              SlidableAction(
                                label: 'Delete',
                                backgroundColor: Colors.red,
                                icon: Icons.delete,
                                onPressed: (context) {
                                  setState(() {
                                    Fluttertoast.showToast(
                                        msg:
                                            "${_contacts[index].split("***")[0]} removed!");
                                    _contacts.removeAt(index);
                                    updateNewContactList(_contacts);
                                  });
                                },
                              ),
                            ],
                          ),
                          child: Container(
                            color: Colors.white,
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.grey[200],
                                backgroundImage: AssetImage("assets/user.png"),
                              ),
                              title: Text(
                                (_contacts[index].split("***")[0]).isNotEmpty
                                    ? _contacts[index].split("***")[0]
                                    : "No Name",
                              ),
                              subtitle: Text(
                                (_contacts[index].split("***")[1]).isNotEmpty
                                    ? _contacts[index].split("***")[1]
                                    : "No Contact",
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              );
            } else {
              return Center(
                child: Text("No Contacts found!"),
              );
            }
          }),
    );
  }

  Future<List<String>> checkforContacts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> contacts = prefs.getStringList("numbers") ?? <String>[];
    print(contacts);
    return contacts;
  }

  updateNewContactList(List<String> contacts) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList("numbers", contacts);
    print(contacts);
  }
}
