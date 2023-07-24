import 'package:contact_app/data/contacts.dart';
import 'package:contact_app/ui/contact_list_page/contact/widget/contactForm.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class ContactEditPage extends StatelessWidget {
  final Contacts editedContact;

  ContactEditPage({
    Key? key,
    required this.editedContact,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact Edit'),
      ),
      body: ContactForm(
        editedContact: editedContact,
      ),
    );
  }
}
