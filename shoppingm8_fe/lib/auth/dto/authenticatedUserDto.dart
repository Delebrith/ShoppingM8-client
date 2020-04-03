class AuthenticatedUserDto {
  final num id;
  final String name;
  final String email;
  final String profilePicture;

  AuthenticatedUserDto(this.id, this.name, this.email, this.profilePicture);
}