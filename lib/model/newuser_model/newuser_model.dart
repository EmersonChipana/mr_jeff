class NewUser {
  final String username;
  final String password;
  final String firstName;
  final String lastName;
  final String email;
  final String numPhone;
  final int gender;
  final String role;
  final String? token;

  NewUser(
      {required this.username,
      required this.password,
      required this.firstName,
      required this.lastName,
      required this.email,
      required this.numPhone,
      required this.gender,
      required this.role,
      this.token});

  @override
  String toString() {
    return 'NewUser: username: $username , password $password , firstname $firstName , lastname $lastName , email: $email , numphone: $numPhone , gender: $gender , role $role token $token';
  }
}
