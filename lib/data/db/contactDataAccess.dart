import 'package:contact_app/data/db/appDataBase.dart';
import 'package:sembast/sembast.dart';

import '../contacts.dart';

class ContactDataAccess {
  static const String CONTACT_STORE_NAME = 'contacts';
  final _contactStore = inMapStoreFactoty.store(CONTACT_STORE_NAME);

  static var inMapStoreFactoty;
  Future<Database> get _db async => AppDatabase.instance.database;
  Future insert(Contacts contacts) async {
    await _contactStore.add(
      await _db,
      contacts.toMap(),
    );
  }

  Future update(Contacts contacts) async {
    final finder = Finder(
      filter: Filter.byKey(contacts.id),
    );
    await _contactStore.update(
      await _db,
      contacts.toMap(),
      finder: finder,
    );
  }

  Future delete(Contacts contacts) async {
    final finder = Finder(
      filter: Filter.byKey(contacts.id),
    );
    await _contactStore.delete(
      await _db,
      finder: finder,
    );
  }

  Future<List<Contacts>> getAllSortedOrder() async {
    final finder = Finder(sortOrders: [
      SortOrder('inFavorite', false),
      SortOrder('name'),
    ]);
    final recordSnapshot = await _contactStore.find(await _db, finder: finder);

    return recordSnapshot.map((snapshot) {
      final contact = Contacts.fromMap(snapshot.value);
      contact.id = snapshot.key;
      return contact;
    }).toList();
  }
}
