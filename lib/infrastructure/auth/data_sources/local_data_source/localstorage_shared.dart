import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@injectable
class LocalstorageShared {
// Add to Shared Pref
   Future<bool?> addToSharedPref(
      {required String key, required var value}) async {
    // Shared Pref instanse
    var sharedPref = await SharedPreferences.getInstance();

    switch (value.runtimeType) {
      case int:
        return await sharedPref.setInt(key, value);
      case bool:
        return await sharedPref.setBool(key, value);
      case double:
        return await sharedPref.setDouble(key, value);
      case String:
        return await sharedPref.setString(key, value);
      case const (List<String>):
        return await sharedPref.setStringList(key, value);
      default:
        return null;
    }
  }

  // Read From Shared Pref
 Future<dynamic>  readFromSharedPref(String key, Type type) async {
    // Shared Pref instanse
    var sharedPref = await SharedPreferences.getInstance();

    // Read Data
    switch (type) {
      case int:
        return sharedPref.getInt(key);

      case bool:
        return sharedPref.getBool(key);

      case double:
        return sharedPref.getDouble(key);

      case String:
        return sharedPref.getString(key);

      case const (List<String>):
        return sharedPref.getStringList(key);
    }
  }

   deleteFromSharedPref(String key) async {
    var sharedPref = await SharedPreferences.getInstance();

    await sharedPref.remove(key);
  }

   updateDataInSharedPref(
      {required String key, required var value}) async {
    var sharedPref = await SharedPreferences.getInstance();

    switch (value.runtimeType) {
      case int:
        await sharedPref.setInt(key, value);
        break;
      case bool:
        await sharedPref.setBool(key, value);
        break;
      case double:
        await sharedPref.setDouble(key, value);
        break;
      case String:
        await sharedPref.setString(key, value);
        break;
      case const (List<String>):
        await sharedPref.setStringList(key, value);
        break;
    }
  }
}