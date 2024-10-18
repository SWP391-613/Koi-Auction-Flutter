import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone_flutter/constants/endpoints.dart';
import 'package:instagram_clone_flutter/models/koi.dart';
import 'package:instagram_clone_flutter/services/auth_service.dart';
import 'package:instagram_clone_flutter/utils/currency.dart';
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
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        setState(() {
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Two koi items per row
            childAspectRatio: 0.7, // Adjust the aspect ratio for better fit
            crossAxisSpacing: 8.0, // Space between columns
            mainAxisSpacing: 8.0, // Space between rows
          ),
          itemCount: koiList!.length,
          itemBuilder: (context, index) {
            final koi = koiList![index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => KoiDetailPage(koiId: koi.id),
                  ),
                );
              },
              child: Card(
                elevation: 4,
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: 200, // Fixed height for the card
                          decoration: const BoxDecoration(
                            color: Color(0xFF1365B4), // Background color
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(10),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 0,
                          right: 0,
                          top: 0,
                          bottom: 0,
                          child: Align(
                            alignment: Alignment.center,
                            child: Transform.scale(
                              scale: 0.9, // Scale the image to 80%
                              child: Image.network(
                                koi.thumbnail,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            koi.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text('Price: ${formatCurrency(koi.basePrice)}'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
