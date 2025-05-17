class SummaryCustomerDto {
  final String id;
  final String name;
  final String surname;
  final String phoneNumber;

  SummaryCustomerDto({
    required this.id,
    required this.name,
    required this.surname,
    required this.phoneNumber,
  });

  factory SummaryCustomerDto.fromJson(Map<String, dynamic> json) {
    return SummaryCustomerDto(
      id: json['id'],
      name: json['name'],
      surname: json['surname'],
      phoneNumber: json['phoneNumber'],
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

  SummaryCustomerDto copyWith({
    String? id,
    String? name,
    String? surname,
    String? phoneNumber,
  }) {
    return SummaryCustomerDto(
      id: id ?? this.id,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }
}
