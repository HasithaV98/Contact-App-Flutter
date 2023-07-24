import 'package:contact_app/data/contacts.dart';
import 'package:contact_app/ui/contact_list_page/contact/contactCreatePage.dart';
import 'package:contact_app/ui/contact_list_page/model/contactModel.dart';
import 'package:contact_app/ui/contact_list_page/widget/contact_tile.dart';
import 'package:flutter/material.dart';
import 'package:faker/faker.dart' as faker;
import 'package:scoped_model/scoped_model.dart';

class ConactListPage extends StatefulWidget {
  @override
  State<ConactListPage> createState() => _ConactListPageState();
}

class _ConactListPageState extends State<ConactListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts'),
      ),
      body:
          ScopedModelDescendant<ContactModel>(builder: (context, child, model) {
        if (model.isLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return ListView.builder(
            itemCount: model.contacts.length,
            //Run and Build item
            itemBuilder: (context, index) {
              return ContactTile(
                contactIndex: index,
              );
            },
          );
        }
      }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.person_add),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => ContactCreatePage()),
          );
        },
      ),
    );
  }
}
