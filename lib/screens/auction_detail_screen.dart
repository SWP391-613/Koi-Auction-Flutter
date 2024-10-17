import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:instagram_clone_flutter/constants/endpoints.dart';

class AuctionDetailPage extends StatefulWidget {
  final int auctionId;

  const AuctionDetailPage({Key? key, required this.auctionId}) : super(key: key);

  @override
  _AuctionDetailPageState createState() => _AuctionDetailPageState();
}

class _AuctionDetailPageState extends State<AuctionDetailPage> {
  bool isLoading = true;
  Map<String, dynamic>? auctionDetails;
  final Dio dio = Dio();

  @override
  void initState() {
    super.initState();
    fetchAuctionDetails();
  }

  Future<void> fetchAuctionDetails() async {
    try {
      final response = await dio.get("$auctionEndpoint/${widget.auctionId}");

      if (response.statusCode == 200) {
        setState(() {
          auctionDetails = response.data; // Store the auction details
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          auctionDetails = null; // Handle error case
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        auctionDetails = null; // Handle exceptions
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text('Auction Detail')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (auctionDetails == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Auction Detail')),
        body: Center(child: Text('No auction details available')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(auctionDetails!['title'])),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Title: ${auctionDetails!['title']}', style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            Text('Start Time: ${auctionDetails!['start_time']}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('End Time: ${auctionDetails!['end_time']}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('Status: ${auctionDetails!['status']}', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
