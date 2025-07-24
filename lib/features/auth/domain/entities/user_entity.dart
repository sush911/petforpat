class UserEntity {
  final String id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String phoneNumber; // <-- not int!
  final String address;
  final String? profileImage;

  UserEntity({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.address,
    this.profileImage,
  });
}
