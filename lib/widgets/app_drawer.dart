import 'package:flutter/material.dart';
import 'package:instagram_clone_flutter/providers/user_provider.dart';
import 'package:instagram_clone_flutter/screens/auction_list_screen.dart';
import 'package:instagram_clone_flutter/screens/koi_list_screen.dart';
import 'package:instagram_clone_flutter/screens/login_screen.dart';
import 'package:instagram_clone_flutter/screens/profile_screen.dart';
import 'package:instagram_clone_flutter/screens/signup_screen.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xFF1365B4),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Welcome to Auction Koi',
                  style: TextStyle(
                    color: Color(0xFFF1F1F1),
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 8), // Space between the text and image
                Expanded(
                  child: Center(
                    child: Image.network(
                      'https://auctionkoi.com/images/breeders-transparent.png',
                      fit: BoxFit.cover, // Adjust the image to contain within the available space
                    ),
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.gavel),
            title: const Text('My Profile'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen(uid: user?.id ?? 0)),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.pets),
            title: const Text('Koi List'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const KoiListPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.gavel),
            title: const Text('Auction List'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const AuctionListPage()),
              );
            },
          ),
          if (user == null) ...[
            ListTile(
              leading: const Icon(Icons.login),
              title: const Text('Login'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.app_registration),
              title: const Text('Register'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const SignupScreen()),
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}