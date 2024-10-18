import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_clone_flutter/providers/user_provider.dart';
import 'package:instagram_clone_flutter/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:provider/single_child_widget.dart';

// This function will be used to set up all the providers (DI).
List<SingleChildWidget> providers = [
  Provider<FirebaseFirestore>(create: (_) => FirebaseFirestore.instance),
  Provider<FirebaseAuth>(create: (_) => FirebaseAuth.instance),
  Provider<Dio>(create: (_) => Dio()),
  Provider<AuthService>(create: (_) => AuthService()),
  ChangeNotifierProvider<UserProvider>(create: (_) => UserProvider()),
];
