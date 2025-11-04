Future<Map<String, Object?>> fetchLocationData(int id) async {
  await Future.delayed(const Duration(seconds: 1));

  return locationsList.firstWhere(
    (location) => location['id'] == id,
    orElse: () => {},
  );
}

const locationsList = [
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
