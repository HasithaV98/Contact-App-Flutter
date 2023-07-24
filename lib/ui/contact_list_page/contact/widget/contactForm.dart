import 'dart:io';
import 'dart:math';

import 'package:contact_app/data/contacts.dart';
import 'package:contact_app/ui/contact_list_page/model/contactModel.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:image_picker/image_picker.dart';

class ContactForm extends StatefulWidget {
  final Contacts editedContact;

  ContactForm({
    Key? key,
    required this.editedContact,
  }) : super(key: key);

  @override
  _ContactFormState createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  final _formKey = GlobalKey<FormState>();

  late String _name;
  late String _email;
  late String _phonenumber;
  late File _contactImageFile;
  bool get hasSelectedCustomImage => _contactImageFile != null;
  bool get isEditMode => widget.editedContact != null;

  @override
  void initState() {
    _contactImageFile = widget.editedContact.imageFile;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          _buildContactPicture(),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            onSaved: (value) => _name = value!,
            validator: _validateName,
            initialValue: widget.editedContact.name,
            decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                )),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            onSaved: (value) => _email = value!,
            validator: _validateEmail,
            initialValue: widget.editedContact.email,
            decoration: InputDecoration(
                labelText: 'Email',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            onSaved: (value) => _phonenumber = value!,
            validator: _validatePhoneNumber,
            initialValue: widget.editedContact.phonenumber,
            decoration: InputDecoration(
                labelText: 'Phone Number',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
          ),
          SizedBox(
            height: 10,
          ),
          ElevatedButton(
            onPressed: _onSavedContactButtonPressed,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Save Contact'),
                Icon(
                  Icons.person,
                  size: 18,
                )
              ],
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildContactPicture() {
    final halfScreenDiameter = MediaQuery.of(context).size.width / 2;
    return Hero(
      tag: widget.editedContact.hashCode,
      child: GestureDetector(
        onTap: _onContactPictureTapped,
        child: CircleAvatar(
          radius: halfScreenDiameter / 2,
          child: _buildCirculAvatarContent(halfScreenDiameter),
        ),
      ),
    );
  }

  void _onContactPictureTapped() async {
    final imageFile = await ImagePicker.platform
        .getImageFromSource(source: ImageSource.gallery);
    setState(() {
      _contactImageFile = imageFile as File;
    });
  }

  Widget _buildCirculAvatarContent(double halfScreenDiameter) {
    if (isEditMode || hasSelectedCustomImage) {
      return _buildEditModeCirculAvatarContent(halfScreenDiameter);
    } else {
      return Icon(
        Icons.person,
        size: halfScreenDiameter / 2,
      );
    }
  }

  Widget _buildEditModeCirculAvatarContent(double halfScreenDiameter) {
    if (_contactImageFile == null) {
      return Text(
        widget.editedContact.name[0],
        style: TextStyle(fontSize: halfScreenDiameter / 2),
      );
    } else {
      return ClipOval(
          child: AspectRatio(
              aspectRatio: 1,
              child: Image.file(
                _contactImageFile,
                fit: BoxFit.cover,
              )));
    }
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Enter Name';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    final emailRegex = RegExp(
        r"/^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$/");
    if (value == null || value.isEmpty) {
      return 'Enter Email';
    } else if (!emailRegex.hasMatch(value)) {
      return "Enter a Valid Address";
    }
    return null;
  }

  String? _validatePhoneNumber(String? value) {
    final phoneRegex =
        RegExp(r'^(\+\d{1,2}\s)?\(?\d{3}\)?[\s.-]\d{3}[\s.-]\d{4}$');
    if (value == null || value.isEmpty) {
      return "Enter Phone Number";
    } else if (!phoneRegex.hasMatch(value)) {
      return "Enter Valid Phone Number";
    }
    return null;
  }

  void _onSavedContactButtonPressed() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState?.save();
    }
    _formKey.currentState?.save();
    final newOrEditedContact = Contacts(
        name: _name,
        email: _email,
        phonenumber: _phonenumber,
        inFavorite: widget.editedContact.inFavorite,
        imageFile: _contactImageFile);

    if (isEditMode) {
      newOrEditedContact.id = widget.editedContact.id;
      ScopedModel.of<ContactModel>(context).updateContact(
        newOrEditedContact,
      );
    } else {
      ScopedModel.of<ContactModel>(context).addContacts(newOrEditedContact);
    }

    Navigator.of(context).pop();
  }
}
