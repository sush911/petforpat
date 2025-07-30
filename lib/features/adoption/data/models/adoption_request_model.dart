class AdoptionRequestModel {
  final String petId;
  final String petName;
  final String petType;
  final String fullName;
  final String citizenshipNumber;
  final String phoneNumber;
  final String email;
  final String homeAddress;
  final String reason;

  AdoptionRequestModel({
    required this.petId,
    required this.petName,
    required this.petType,
    required this.fullName,
    required this.citizenshipNumber,
    required this.phoneNumber,
    required this.email,
    required this.homeAddress,
    required this.reason,
  });

  Map<String, dynamic> toJson() {
    return {
      'petId': petId,
      'petName': petName,
      'petType': petType,
      'fullName': fullName,
      'citizenshipNumber': citizenshipNumber,
      'phoneNumber': phoneNumber,
      'email': email,
      'homeAddress': homeAddress,
      'reason': reason,
    };
  }
}
