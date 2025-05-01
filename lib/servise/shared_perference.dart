import 'package:shared_preferences/shared_preferences.dart';

class SharedPerference {
  static Future<void> storeName(String email,String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('email', email,);
    await prefs.setString('name', name);
  }

  static Future<Map<String, String?>> loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');
    String? name = prefs.getString('name');
    return {
      'email': email,
      'name': name,
    };
  }

}
