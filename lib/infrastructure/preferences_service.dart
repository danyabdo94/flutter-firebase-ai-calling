import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const String _locationsKey = 'locations_list';

  Future<void> saveLocations(List<Map<String, Object?>> locations) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(locations);
    await prefs.setString(_locationsKey, jsonString);
  }

  Future<List<Map<String, Object?>>> getLocations() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_locationsKey);

    if (jsonString == null) {
      return [];
    }

    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.cast<Map<String, Object?>>();
  }

  Future<void> clearLocations() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_locationsKey);
  }

  Future<void> updateLocation(int id, Map<String, Object?> updatedLocation) async {
    final locations = await getLocations();
    final index = locations.indexWhere((location) => location['id'] == id);

    if (index != -1) {
      locations[index] = updatedLocation;
      await saveLocations(locations);
    }
  }

  Future<void> deleteLocation(int id) async {
    final locations = await getLocations();
    locations.removeWhere((location) => location['id'] == id);
    await saveLocations(locations);
  }

  Future<void> addLocation(Map<String, Object?> newLocation) async {
    final locations = await getLocations();
    locations.add(newLocation);
    await saveLocations(locations);
  }
}
