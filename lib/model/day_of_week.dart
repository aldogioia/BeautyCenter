enum DayOfWeek {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday;

  static DayOfWeek fromString(String value) {
    return DayOfWeek.values.firstWhere(
          (e) => e.name.toUpperCase() == value.toUpperCase(),
      orElse: () => throw ArgumentError('Invalid day: $value'),
    );
  }

  static getItalianName(String value){
    switch(value){
      case 'monday':
        return "Lunedì";
      case 'tuesday':
        return "Martedi";
      case 'wednesday':
        return "Mercoledì";
      case 'thursday':
        return "Giovedì";
      case 'friday':
        return "Venerdì";
      case 'saturday':
        return "Sabato";
      case 'sunday':
        return "Domenica";
    }
  }

  String toJson() => name.toUpperCase();
}