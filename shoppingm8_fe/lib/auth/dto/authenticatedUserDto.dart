class AuthenticatedUserDto {
  final num id;
  final String name;
  final String email;
  final String profilePicture;

  AuthenticatedUserDto({this.id, this.name, this.email, this.profilePicture});
  
  factory AuthenticatedUserDto.fromJson(Map<String, dynamic> json) {
    return AuthenticatedUserDto(
        id: json['id'],
        name: json['name'],
        email: json['email'],
        profilePicture: json['profilePicture']
    );
  }
}