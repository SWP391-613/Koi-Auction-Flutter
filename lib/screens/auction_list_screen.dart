import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:instagram_clone_flutter/constants/endpoints.dart';
import 'package:instagram_clone_flutter/models/auction.dart';
import 'package:instagram_clone_flutter/screens/auction_detail_screen.dart';
import 'package:instagram_clone_flutter/widgets/app_drawer.dart';

class AuctionListPage extends StatefulWidget {
  const AuctionListPage({Key? key}) : super(key: key);

  @override
  _AuctionListPageState createState() => _AuctionListPageState();
}

class _AuctionListPageState extends State<AuctionListPage> {
  bool isLoading = true;
  List<Auction>? auctionList; // Use the Auction model
  final Dio dio = Dio();
  final int page = 0;
  final int limit = 10;

  @override
  void initState() {
    super.initState();
    fetchAuctionList();
  }

  Future<void> fetchAuctionList() async {
    try {
      final response = await dio.get("$auctionEndpoint?page=$page&limit=$limit");

      if (kDebugMode) {
        print("Response auction list: $response");
      }

      if (response.statusCode == 200) {
        setState(() {
          auctionList = (response.data as List)
              .map((auction) => Auction.fromJson(auction))
              .toList(); // Convert JSON to Auction objects
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          auctionList = null; // Handle error case
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        auctionList = null; // Handle exceptions
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Auction List')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (auctionList == null || auctionList!.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Auction List')),
        body: const Center(child: Text('No auction data available')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Auction List')),
      drawer: const AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(8.0), // Add padding around the grid
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Two auctions per row
            childAspectRatio: 1, // Aspect ratio for each item
            crossAxisSpacing: 10, // Space between columns
            mainAxisSpacing: 10, // Space between rows
          ),
          itemCount: auctionList!.length,
          itemBuilder: (context, index) {
            final auction = auctionList![index];
            Color auctionStatusTextColor = auction.status == 'ENDED' ? Colors.red : Colors.green;
            return GestureDetector(
              onTap: () {
                // Navigate to AuctionDetailPage and pass the selected auction's ID
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AuctionDetailPage(auctionId: auction.id),
                  ),
                );
              },
              child: Card(
                elevation: 3, // Shadow effect
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Rounded corners
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        auction.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Start Date: ${auction.startTime}',
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'End Date: ${auction.endTime}',
                      ),
                      Text(
                        'Status: ${auction.status}',
                        style: TextStyle(fontSize: 14, color: auctionStatusTextColor),
                      ),
                      // Add more auction details here if needed
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
