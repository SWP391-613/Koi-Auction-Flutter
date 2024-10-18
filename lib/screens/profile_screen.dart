import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone_flutter/constants/endpoints.dart';
import 'package:instagram_clone_flutter/models/user_profile.dart';
import 'package:shared_preferences/shared_preferences.dart'; // For clearing stored session tokens

class ProfileScreen extends StatefulWidget {
  final int uid; // User ID passed from previous screen
  const ProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Dio _dio;
  bool _isLoading = true;
  UserProfile? _userProfile;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _dio = Dio();
    _fetchUserProfile();
  }

  // Function to fetch the user profile from the API
  Future<void> _fetchUserProfile() async {
    try {
      final response = await _dio.get('$userEndpoint/${widget.uid}');
      setState(() {
        _userProfile = UserProfile.fromJson(response.data);
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _errorMessage = 'Error fetching user data';
        _isLoading = false;
      });
    }
  }

  // Function to handle logout and navigate back to the login screen
  Future<void> _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear all session-related data (like tokens)
    Navigator.pushReplacementNamed(context, '/'); // Redirect to login page
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back
          },
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator()) // Loading indicator
          : _errorMessage != null
          ? Center(child: Text(_errorMessage!)) // Show error if there's an issue
          : _userProfile != null
          ? Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _userProfile!.avatarUrl != null
                    ? NetworkImage(_userProfile!.avatarUrl!)
                    : null,
                child: _userProfile!.avatarUrl == null
                    ? const Icon(Icons.person, size: 50)
                    : null,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Name: ${_userProfile!.firstName} ${_userProfile!.lastName}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Email: ${_userProfile!.email}'),
            const SizedBox(height: 8),
            Text('Address: ${_userProfile!.address}'),
            const SizedBox(height: 8),
            Text('Account Active: ${_userProfile!.isActive ? "Yes" : "No"}'),
            const SizedBox(height: 8),
            Text('Account Balance: \$${_userProfile!.accountBalance}'),
            const SizedBox(height: 8),
            Text('Email: ${_userProfile!.email}'),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                // Navigate to EditProfileScreen and pass the user profile data
                Navigator.pushNamed(context, '/edit_profile',
                    arguments: _userProfile);
              },
              child: const Text('Edit Profile'),
            ),
            TextButton(
              onPressed: () => _logout(context), // Logout function
              child: const Text('Logout'),
            ),
          ],
        ),
      )
          : const Center(child: Text('No user data found')),
    );
  }
}
