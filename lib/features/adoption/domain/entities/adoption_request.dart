
// features/adoption/domain/entities/adoption_request.dart
class AdoptionRequest {
  final String petId;
  final String petName;
  final String petType;
  final String fullName;
  final String citizenshipNumber;
  final String phoneNumber;
  final String email;
  final String homeAddress;
  final String reason;

  AdoptionRequest({
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
}