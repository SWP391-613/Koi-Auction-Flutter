class UserProfile {
  final int id;
  final String firstName;
  final String lastName;
  final String? phoneNumber;
  final String email;
  final String address;
  final String password; // Assuming you want to store this securely
  final bool isActive;
  final bool isSubscribed; // Renamed for clarity
  final String? statusName; // Can be nullable
  final String dateOfBirth;
  final String? avatarUrl;
  final int googleAccountId;
  final String roleName;
  final int accountBalance;
  final DateTime createdAt; // Changed to DateTime for better handling
  final DateTime updatedAt; // Changed to DateTime for better handling

  UserProfile({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.phoneNumber,
    required this.email,
    required this.address,
    required this.password, // Store this securely
    required this.isActive,
    required this.isSubscribed,
    this.statusName,
    required this.dateOfBirth,
    this.avatarUrl,
    required this.googleAccountId,
    required this.roleName,
    required this.accountBalance,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      phoneNumber: json['phone_number'],
      email: json['email'],
      address: json['address'],
      password: json['password'], // Be cautious with sensitive data
      isActive: json['is_active'] == 1, // Convert from int to bool
      isSubscribed: json['is_subscription'] == 1, // Convert from int to bool
      statusName: json['status_name'],
      dateOfBirth: json['date_of_birth'],
      avatarUrl: json['avatar_url'],
      googleAccountId: json['google_account_id'],
      roleName: json['role_name'],
      accountBalance: json['account_balance'],
      createdAt: DateTime.parse(json['created_at']), // Parse to DateTime
      updatedAt: DateTime.parse(json['updated_at']), // Parse to DateTime
    );
  }
}
