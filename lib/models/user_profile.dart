class UserProfile {
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String address;
  final bool isActive;
  final int id;
  final String? avatarUrl;
  final int accountBalance;

  UserProfile({
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.address,
    required this.isActive,
    required this.id,
    this.avatarUrl,
    required this.accountBalance,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      username: json['username'],
      email: json['email'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      address: json['address'],
      isActive: json['is_active'],
      id: json['id'],
      avatarUrl: json['avatar_url'],
      accountBalance: json['account_balance'],
    );
  }
}
