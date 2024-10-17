import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone_flutter/constants/endpoints.dart';

class KoiDetailPage extends StatefulWidget {
  final int koiId;

  const KoiDetailPage({Key? key, required this.koiId}) : super(key: key);

  @override
  _KoiDetailPageState createState() => _KoiDetailPageState();
}

class _KoiDetailPageState extends State<KoiDetailPage> {
  bool isLoading = true;
  Map<String, dynamic>? koiData;

  final Dio dio = Dio(); // Initialize Dio

  @override
  void initState() {
    super.initState();
    fetchKoiData();
  }

  Future<void> fetchKoiData() async {
    try {
      final response = await dio.get('$koiEndpoint/${widget.koiId}');

      if(kDebugMode){
        print("Response koi details: $response");
      }

      if (response.statusCode == 200) {
        setState(() {
          koiData = response.data; // Directly use response.data
          isLoading = false;
        });
      } else {
        // Handle error case
        setState(() {
          isLoading = false;
          koiData = null; // or show an error message
        });
      }
    } catch (e) {
      // Handle exceptions (e.g., network issues)
      setState(() {
        isLoading = false;
        koiData = null; // or show an error message
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text('Koi Details')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (koiData == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Koi Details')),
        body: Center(child: Text('Failed to load koi data')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(koiData!['name']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(koiData!['thumbnail']),
            SizedBox(height: 10),
            Text(
              'Name: ${koiData!['name']}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text('Sex: ${koiData!['sex']}'),
            Text('Length: ${koiData!['length']} cm'),
            Text('Age: ${koiData!['age']} years'),
            Text('Price: \$${koiData!['base_price']}'),
            Text('Status: ${koiData!['status_name']}'),
            Text('Description: ${koiData!['description']}'),
          ],
        ),
      ),
    );
  }
}
