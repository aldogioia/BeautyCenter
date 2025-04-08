// todo rimuovere? è uguale al CustomerDto
class UpdateCustomerDto {
  final String id;
  final String name;
  final String surname;
  final String email;
  final num phoneNumber;

  UpdateCustomerDto({
    required this.id,
    required this.name,
    required this.surname,
    required this.email,
    required this.phoneNumber,
  });

  UpdateCustomerDto copyWith({
    String? id,
    String? name,
    String? surname,
    String? email,
    num? phoneNumber,
  }) {
    return UpdateCustomerDto(
      id: id ?? this.id,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
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
