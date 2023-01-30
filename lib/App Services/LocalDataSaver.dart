import 'package:shared_preferences/shared_preferences.dart';

class LocalDataSaver {
  static String isRunAppFirstTimeKey = "ISRUNAPPFIRSTTIMEKEY";
  static bool isRunAppFirstTime = true;
  static String emailKey = "EMAILKEY";
  static String nameKey = "NAMEKEY";
  static String userDocKey = "USERDOCKEY";
  static String cartShopNameKey = "shopNameKey";
  static String cartShopIdKey = "shopIdKey";
  static String isCartKey = "isCartKey";
  static String isShopeKey = "ISSHOPEKEY";
  static String deviceTokenKey = "DEVICETOKENKEY";

  static String name = "";
  static String email = "";
  static String userDoc = "";

  static Future<void> setDeviceToken(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(deviceTokenKey, name);
  }

  static Future<String?> getDeviceToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(deviceTokenKey);
  }
// cartted

  static Future<void> setCartShopName(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(cartShopNameKey, name);
  }

  static Future<void> setCartShopId(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(cartShopIdKey, id);
  }

  static Future<void> setIsCart(bool cart) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(isCartKey, cart);
  }

  static Future<String?> getCartShopName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(cartShopNameKey);
  }

  static Future<String?> getCartShopId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(cartShopIdKey);
  }

  static Future<bool?> getIsCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(isCartKey);
  }

  static Future<bool?> getIsShope() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(isShopeKey);
  }

  static Future<void> setIsShope(bool shope) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(isShopeKey, shope);
  }

  ///end careyed

  static setIsRunAppFirstTime() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setBool(isRunAppFirstTimeKey, false);
  }

  static Future<bool?> getIsRunAppFirstTime() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool(isRunAppFirstTimeKey);
  }

  // #############
  static setEmail(String email) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString(emailKey, email);
  }

  static Future<String?> getEmail() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    email = preferences.getString(emailKey)!;
    return email;
  }
// ####################

  static setName(String nam) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString(nameKey, nam);
  }

  static Future<String?> getName() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    name = (await preferences.getString(nameKey))!;
    return name;
  }

// ####################
  static setUserId(String id) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString(userDocKey, id);
  }

  static Future<String?> getUserId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    userDoc = preferences.getString(userDocKey)!;
    return userDoc;
  }
// ####################
}
