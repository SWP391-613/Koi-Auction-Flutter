import 'dart:convert';  // For JSON encoding
import 'package:dio/dio.dart';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:instagram_clone_flutter/constants/endpoints.dart';
import 'package:instagram_clone_flutter/models/user.dart' as model;
import 'package:instagram_clone_flutter/resources/storage_methods.dart';
import 'package:instagram_clone_flutter/services/auth_service.dart';

class AuthMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Dio _dio = Dio(); // Create a Dio instance
  final AuthService _authService = AuthService();

  // Logging in user via HTTP request
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      if (email.isEmpty || password.isEmpty) {
        return "Please enter all the fields";
      }

      if (kDebugMode) {
        print("Logging in with email: $email and password: $password");
      }

      final response = await _dio.post(
        loginEndpoint,
        data: {
          'email': email,
          'password': password,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
          validateStatus: (status) => status! < 500,
        ),
      );

      if (response.statusCode == 200) {

        // Get token and refresh_token from the response
        String token = response.data['token'];
        String refreshToken = response.data['refresh_token'];

        if (kDebugMode) {
          print("Token: $token");
        }

        // Save tokens to SharedPreferences
        await _authService.saveTokens(token, refreshToken);

        return "success";
      } else {
        String errorMessage = response.data['message'] ?? "Login failed";
        if (kDebugMode) {
          print("Error when logging in: $errorMessage");
          print("Status code: ${response.statusCode}");
          print("Response data: ${response.data}");
        }
        return errorMessage;
      }
    } catch (e) {
      if (kDebugMode) {
        print("Exception occurred during login: $e");
      }
      return "An unexpected error occurred. Please try again later.";
    }
  }

  // get user details
  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot documentSnapshot =
    await _firestore.collection('users').doc(currentUser.uid).get();

    return model.User.fromSnap(documentSnapshot);
  }

  // Signing out user via HTTP request
  Future<String> signOut() async {
    String res = "Some error occurred";

    try {
      const String url = 'http://localhost:4000/api/v1/users/logout';

      final response = await _dio.post(
        url,
        options: Options(
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            // Include any additional headers if required, like authorization tokens
          },
        ),
      );

      if (response.statusCode == 200) {
        res = "success";  // Assuming logout was successful
      } else {
        res = response.data['message'] ?? "Logout failed";
      }
    } catch (e) {
      res = e.toString();
    }

    return res;
  }

  // Signing Up User

  Future<String> signUpUser() async  {
    return "success";
  }

}
