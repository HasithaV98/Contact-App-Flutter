import 'package:contact_app/data/contacts.dart';
import 'package:contact_app/ui/contact_list_page/contact/contactEditPage.dart';
import 'package:contact_app/ui/contact_list_page/model/contactModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

class ContactTile extends StatelessWidget {
  ContactTile({
    Key? key,
    required this.contactIndex,
    //required this.onFavoritePressed,
  }) : super(key: key);

  final int contactIndex;
  //final void Funnction() onFavoritePressed;

  @override
  Widget build(BuildContext context) {
    final model = ScopedModel.of<ContactModel>(context);
    final displayedContact = model.contacts[contactIndex];
    return Slidable(
      startActionPane: ActionPane(
        motion: const StretchMotion(),
        children: [
          SlidableAction(
            onPressed: (context) => _callPhoneNumber(
              context,
              displayedContact.phonenumber,
            ),
            backgroundColor: Colors.green,
            label: 'Call',
            icon: Icons.call,
          ),
          SlidableAction(
            onPressed: ((context) =>
                _writeEmail(context, displayedContact.email)),
            backgroundColor: Colors.blue,
            label: 'Email',
            icon: Icons.email,
          ),
        ],
      ),
      endActionPane: ActionPane(
        motion: const StretchMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              model.deleteContact(displayedContact);
            },
            backgroundColor: Colors.red,
            label: 'Delete',
            icon: Icons.delete,
          )
        ],
      ),
      child: _buildContent(context, displayedContact, model),
    );
  }

  Future _callPhoneNumber(BuildContext context, String number) async {
    final url = 'tel:$number';
    if (await url_launcher.canLaunch(url)) {
      await url_launcher.launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Cannot make a call'),
        ),
      );
    }
  }

  Future _writeEmail(BuildContext context, String emailAddress) async {
    final url = 'mailto:$emailAddress';
    if (await url_launcher.canLaunch(url)) {
      await url_launcher.launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Cannot write an email'),
      ));
    }
  }

  Container _buildContent(
    BuildContext context,
    Contacts displayedContact,
    ContactModel model,
  ) {
    return Container(
      color: Theme.of(context).canvasColor,
      child: ListTile(
        title: Text(displayedContact.name),
        subtitle: Text(displayedContact.email),
        leading: _buildCirculAvatar(displayedContact),
        trailing: IconButton(
            onPressed: () {
              model.changeFavoriteStatus(displayedContact);
            },
            icon: Icon(
              displayedContact.inFavorite ? Icons.star : Icons.star_border,
              color: displayedContact.inFavorite ? Colors.amber : Colors.grey,
            )),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => ContactEditPage(
              editedContact: displayedContact,
            ),
          ));
        },
      ),
    );
  }

  Hero _buildCirculAvatar(Contacts displayedContact) {
    return Hero(
        tag: displayedContact.hashCode,
        child: CircleAvatar(
          child: _buildCirculAvatarContent(displayedContact),
        ));
  }

  Widget _buildCirculAvatarContent(Contacts displayedContact) {
    if (displayedContact.imageFile == null) {
      return Text(displayedContact.name[0]);
    } else {
      return ClipOval(
        child: AspectRatio(
          aspectRatio: 1,
          child: Image.file(
            displayedContact.imageFile,
            fit: BoxFit.cover,
          ),
        ),
      );
    }
  }
}
