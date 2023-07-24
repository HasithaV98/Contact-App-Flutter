import 'package:contact_app/data/contacts.dart';
import 'package:contact_app/data/db/contactDataAccess.dart';
import 'package:faker/faker.dart' as faker;
import 'package:scoped_model/scoped_model.dart';

class ContactModel extends Model {
  final ContactDataAccess _contactDataAccess = ContactDataAccess();
  late List<Contacts> _contacts;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  List<Contacts> get contacts => _contacts;

  Future loadContacts() async {
    _isLoading = true;
    notifyListeners();
    _contacts = await _contactDataAccess.getAllSortedOrder();
    _isLoading = false;
    notifyListeners();
  }

  Future addContacts(Contacts contacts) async {
    await _contactDataAccess.insert(contacts);
    await loadContacts();

    notifyListeners();
  }

  Future updateContact(Contacts contacts) async {
    await _contactDataAccess.update(contacts);
    await loadContacts();
    notifyListeners();
  }

  Future deleteContact(Contacts contacts) async {
    await _contactDataAccess.delete(contacts);
    await loadContacts();
    notifyListeners();
  }

  Future changeFavoriteStatus(Contacts contacts) async {
    contacts.inFavorite = !contacts.inFavorite;
    await _contactDataAccess.update(contacts);
    _contacts = await _contactDataAccess.getAllSortedOrder();
    notifyListeners();
  }
}
