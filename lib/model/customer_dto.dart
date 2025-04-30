class CustomerDto {
  final String id;
  final String name;
  final String surname;
  final String email;
  final num phoneNumber;

  CustomerDto({
    required this.id,
    required this.name,
    required this.surname,
    required this.email,
    required this.phoneNumber,
  });

  CustomerDto copyWith({
    String? id,
    String? name,
    String? surname,
    String? email,
    num? phoneNumber,
  }) {
    return CustomerDto(
      id: id ?? this.id,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }

  factory CustomerDto.fromJson(Map<String, dynamic> json) {
    return CustomerDto(
      id: json['id'] as String,
      name: json['name'] as String,
      surname: json['surname'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as num,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'surname': surname,
      'email': email,
      'phoneNumber': phoneNumber,
    };
  }
}
