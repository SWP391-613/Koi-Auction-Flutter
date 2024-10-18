import 'package:flutter/material.dart';
import 'package:instagram_clone_flutter/models/user_profile.dart';

class ProfileScreen extends StatelessWidget {
  final String uid;

  const ProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Replace with your data fetching logic, for example, an API call to fetch user data
    final userData = {
      "id": 4,
      "createdAt": [2024, 9, 27, 22, 21, 18, 973575000],
      "updatedAt": [2024, 9, 27, 22, 21, 18, 973595000],
      "role": {"id": 1, "name": "member"},
      "enabled": true,
      "username": "hoangdz1604@gmail.com",
      "authorities": [{"authority": "ROLE_MEMBER"}],
      "accountNonExpired": true,
      "accountNonLocked": true,
      "credentialsNonExpired": true,
      "first_name": "Bao",
      "last_name": "Chau",
      "phone_number": null,
      "email": "ybjow@gmail.com",
      "address": "Hoa Khanh, Da Nang",
      "password": "...", // Hide password for security
      "is_active": false,
      "is_subscription": false,
      "status": null,
      "date_of_birth": 1097712000000,
      "avatar_url": "https://scontent.fsgn19-1.fna.fbcdn.net/v/t39.30808-6/281656840_1346404902531656_736225023402507132_n.jpg?stp=dst-jpg_s206x206&_nc_cat=111&ccb=1-7&_nc_sid=50ad20&_nc_ohc=cYMAxnhsudQQ7kNvgGYW5H-&_nc_ht=scontent.fsgn19-1.fna&_nc_gid=AyDs4YR_9pcg7iijF98nENJ&oh=00_AYCW4H7pDS7eVp7XYOETdFnevuPSokHiqMAykK1dNvCgww&oe=6717B460",
      "google_account_id": 0,
      "account_balance": 0,
    };

    // Parse the user data
    UserProfile userProfile = UserProfile.fromJson(userData);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back to AuctionListPage
          },
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: userProfile.avatarUrl != null
                    ? NetworkImage(userProfile.avatarUrl!)
                    : null,
                child: userProfile.avatarUrl == null
                    ? const Icon(Icons.person, size: 50)
                    : null,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Name: ${userProfile.firstName} ${userProfile.lastName}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Email: ${userProfile.email}'),
            const SizedBox(height: 8),
            Text('Address: ${userProfile.address}'),
            const SizedBox(height: 8),
            Text('Account Active: ${userProfile.isActive ? "Yes" : "No"}'),
            const SizedBox(height: 8),
            Text('Account Balance: \$${userProfile.accountBalance}'),
            const SizedBox(height: 8),
            Text('Username: ${userProfile.username}'),
          ],
        ),
      ),
    );
  }
}
