class UserDto {
  final num id;
  final String name;
  final String profilePicture;

  UserDto({this.id, this.name, this.profilePicture});

  factory UserDto.fromJson(Map<String, dynamic> json) {
    return UserDto(
        id: json['id'],
        name: json['name'],
        profilePicture: json['profilePicture']
    );
  }
}