import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone_flutter/constants/endpoints.dart';
import 'package:instagram_clone_flutter/services/auth_service.dart';
import 'package:instagram_clone_flutter/widgets/app_drawer.dart';

import 'koi_detail_screen.dart';

class KoiListAuctionPage extends StatefulWidget {
  const KoiListAuctionPage({Key? key}) : super(key: key);

  @override
  _KoiListAuctionPageState createState() => _KoiListAuctionPageState();
}

class _KoiListAuctionPageState extends State<KoiListAuctionPage> {
  bool isLoading = true;
  List<dynamic>? koiList;
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
      final response = await dio.get("$koiEndpoint?page=$page&limit=$limit",
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',  // Include Bearer token in the header
            },
          ));

      if (response.statusCode == 200) {
        setState(() {
          koiList = response.data['item']; // Store the list of koi
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
            leading: Image.network(koi['thumbnail'], width: 50, height: 80, fit: BoxFit.cover),
            title: Text(koi['name']),
            subtitle: Text('Price: \$${koi['base_price']}'),
            onTap: () {
              // Navigate to KoiDetailPage and pass the selected koi's ID
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => KoiDetailPage(koiId: koi['id']),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
