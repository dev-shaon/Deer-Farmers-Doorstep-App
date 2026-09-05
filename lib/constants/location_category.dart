enum LocationCategory {
  farms,
  ranches,
  events;

  String get apiType {
    switch (this) {
      case LocationCategory.farms:
        return 'farm';
      case LocationCategory.ranches:
        return 'ranch';
      case LocationCategory.events:
        return 'event';
    }
  }
}