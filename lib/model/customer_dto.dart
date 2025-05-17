class CustomerDto {
  final String id;
  final String name;
  final String surname;
  final String phoneNumber;

  CustomerDto({
    required this.id,
    required this.name,
    required this.surname,
    required this.phoneNumber,
  });

  CustomerDto copyWith({
    String? id,
    String? name,
    String? surname,
    String? email,
    String? phoneNumber,
  }) {
    return CustomerDto(
      id: id ?? this.id,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }

  factory CustomerDto.fromJson(Map<String, dynamic> json) {
    return CustomerDto(
      id: json['id'] as String,
      name: json['name'] as String,
      surname: json['surname'] as String,
      phoneNumber: json['phoneNumber'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'surname': surname,
      'phoneNumber': phoneNumber,
    };
  }

  static empty() {
    return CustomerDto(
      id: '',
      name: '',
      surname: '',
      phoneNumber: '',
    );
  }

  bool isEmpty() {
    return id.isEmpty &&
        name.isEmpty &&
        surname.isEmpty &&
        phoneNumber.isEmpty;
  }
}
