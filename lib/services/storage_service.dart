import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/spell_model.dart';

class StorageService {
  static const String _keyIsLoggedIn = 'isLoggedIn';
  static const String _keyUsername = 'username';
  static const String favoriteSpellsBoxName = 'favorite_spells';

  static Future<void> saveLoginSession(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, true);
    await prefs.setString(_keyUsername, username);
  }

  static Future<bool> checkLoginSession() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  static Future<void> clearLoginSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, false);
  }

  static Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUsername);
  }

  static Future<Box<SpellModel>> getFavoriteBox() async {
    if (Hive.isBoxOpen(favoriteSpellsBoxName)) {
      return Hive.box<SpellModel>(favoriteSpellsBoxName);
    }
    return await Hive.openBox<SpellModel>(favoriteSpellsBoxName);
  }

  static Box<SpellModel> getOpenBox() {
    return Hive.box<SpellModel>(favoriteSpellsBoxName);
  }

  static Future<void> addFavoriteSpell(SpellModel spell) async {
    final box = await getFavoriteBox();
    await box.put(spell.spell, spell);
  }

  static Future<void> removeFavoriteSpell(String spellName) async {
    final box = await getFavoriteBox();
    await box.delete(spellName);
  }

  static Future<bool> isFavorite(String spellName) async {
    final box = await getFavoriteBox();
    return box.containsKey(spellName);
  }

  static Future<List<SpellModel>> getFavoriteSpells() async {
    final box = await getFavoriteBox();
    return box.values.toList();
  }
}
