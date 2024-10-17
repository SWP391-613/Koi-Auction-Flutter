import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:instagram_clone_flutter/constants/endpoints.dart';
import 'package:instagram_clone_flutter/screens/auction_detail_screen.dart';
import 'package:instagram_clone_flutter/widgets/app_drawer.dart';

class AuctionListPage extends StatefulWidget {
  const AuctionListPage({Key? key}) : super(key: key);

  @override
  _AuctionListPageState createState() => _AuctionListPageState();
}

class _AuctionListPageState extends State<AuctionListPage> {
  bool isLoading = true;
  List<dynamic>? auctionList;
  final Dio dio = Dio();
  final int page = 1;
  final int limit = 10;

  @override
  void initState() {
    super.initState();
    fetchAuctionList();
  }

  Future<void> fetchAuctionList() async {
    try {
      final response = await dio.get("$auctionEndpoint?page=$page&limit=$limit");

      if (response.statusCode == 200) {
        setState(() {
          auctionList = response.data; // Store the list of auctions
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
      body: ListView.builder(
        itemCount: auctionList!.length,
        itemBuilder: (context, index) {
          final auction = auctionList![index];
          return ListTile(
            title: Text(auction['title']),
            subtitle: Text('Status: ${auction['status']}'),
            onTap: () {
              // Navigate to AuctionDetailPage and pass the selected auction's ID
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AuctionDetailPage(auctionId: auction['id']),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
