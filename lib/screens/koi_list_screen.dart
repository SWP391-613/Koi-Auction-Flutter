import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone_flutter/constants/endpoints.dart';
import 'package:instagram_clone_flutter/models/koi.dart';
import 'package:instagram_clone_flutter/services/auth_service.dart';
import 'package:instagram_clone_flutter/widgets/app_drawer.dart';

import 'koi_detail_screen.dart';

class KoiListPage extends StatefulWidget {
  const KoiListPage({Key? key}) : super(key: key);

  @override
  _KoiListPageState createState() => _KoiListPageState();
}

class _KoiListPageState extends State<KoiListPage> {
  bool isLoading = true;
  List<Koi>? koiList;
  final AuthService _authService = AuthService();
  final Dio dio = Dio();
  final int page = 0;
  final int limit = 10;

  @override
  void initState() {
    super.initState();
    fetchKoiList();
  }

  Future<void> fetchKoiList() async {
    String? token = await _authService.getToken();

    try {
      final response = await dio.get(
        "$koiEndpoint?page=$page&limit=$limit",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token', // Include Bearer token in the header
          },
        ),
      );

      if (response.statusCode == 200) {
        setState(() {
          // Convert response data to List<Koi>
          koiList = (response.data['item'] as List)
              .map((koiJson) => Koi.fromJson(koiJson))
              .toList();
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          koiList = null; // Handle error case
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        koiList = null; // Handle exceptions
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Koi List')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (koiList == null || koiList!.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Koi List')),
        body: const Center(child: Text('No koi data available')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Koi List')),
      drawer: const AppDrawer(),
      body: ListView.builder(
        itemCount: koiList!.length,
        itemBuilder: (context, index) {
          final koi = koiList![index];
          return ListTile(
            leading: Image.network(
              koi.thumbnail,
              width: 50,
              height: 80,
              fit: BoxFit.cover,
            ),
            title: Text(koi.name),
            subtitle: Text('Price: \$${koi.basePrice}'),
            onTap: () {
              // Navigate to KoiDetailPage and pass the selected koi's ID
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => KoiDetailPage(koiId: koi.id),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
