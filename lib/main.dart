import 'package:contact_app/ui/contact_list_page/contact/contactCreatePage.dart';
import 'package:contact_app/ui/contact_list_page/contact_list.dart';
import 'package:contact_app/ui/contact_list_page/model/contactModel.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScopedModel(
      model: ContactModel()..loadContacts(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Contacts',
        theme: ThemeData(
          primarySwatch: Colors.lightGreen,
        ),
        home: ConactListPage(),
      ),
    );
  }
}
