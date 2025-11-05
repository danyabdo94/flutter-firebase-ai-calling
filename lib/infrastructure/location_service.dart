import 'package:sidekik/infrastructure/preferences_service.dart';

final preferencesService = PreferencesService();

// Default locations to initialize if none exist in SharedPreferences
const defaultLocationsList = [
  {
    "id": 10,
    "name": "Emilia's Cafe - UBI-5",
    "street": "Carrer de Pallars",
    "streetNo": "108",
    "streetAndNumber": "Carrer de Pallars 108",
  },
  {
    "id": 11,
    "name": "Deutsche Niederlassung 1",
    "street": "Musterstraße",
    "streetNo": "10A",
    "streetAndNumber": "Musterstraße 10A",
  },
];

Future<void> initializeLocations() async {
  final locations = await preferencesService.getLocations();
  if (locations.isEmpty) {
    await preferencesService.saveLocations(
      defaultLocationsList.cast<Map<String, Object?>>(),
    );
  }
}

Future<Map<String, Object?>> fetchLocationData(int id) async {
  final locations = await preferencesService.getLocations();

  return locations.firstWhere(
    (location) => location['id'] == id,
    orElse: () => {},
  );
}

Future<void> updateLocationName(int id, String updatedLocationName) async {
  final locations = await preferencesService.getLocations();
  final index = locations.indexWhere((location) => location['id'] == id);

  if (index != -1) {
    final updatedLocation = Map<String, Object?>.from(locations[index]);
    updatedLocation['name'] = updatedLocationName;
    locations[index] = updatedLocation;
    await preferencesService.saveLocations(locations);
  }
}

Future<void> updateLocation(
  int id,
  Map<String, Object?> updatedLocation,
) async {
  await preferencesService.updateLocation(id, updatedLocation);
}

Future<void> deleteLocation(int id) async {
  await preferencesService.deleteLocation(id);
}

Future<void> addLocation(Map<String, Object?> newLocation) async {
  await preferencesService.addLocation(newLocation);
}

Future<List<Map<String, Object?>>> getAllLocations() async {
  return await preferencesService.getLocations();
}
