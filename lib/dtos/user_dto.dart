class UserDTO{

  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String confirmPassword;
  final bool isSubscribed;
  final bool isAgreedPolicy;


  UserDTO({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.isSubscribed,
    required this.isAgreedPolicy,
  });


}