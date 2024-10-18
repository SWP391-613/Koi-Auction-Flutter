import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:instagram_clone_flutter/constants/endpoints.dart';
import 'package:instagram_clone_flutter/screens/koi_detail_screen.dart';
import 'package:instagram_clone_flutter/utils/currency.dart';
import 'package:instagram_clone_flutter/utils/date_time.dart';

class AuctionDetailPage extends StatefulWidget {
  final int auctionId;

  const AuctionDetailPage({Key? key, required this.auctionId})
      : super(key: key);

  @override
  _AuctionDetailPageState createState() => _AuctionDetailPageState();
}

class _AuctionDetailPageState extends State<AuctionDetailPage> {
  bool isLoading = true;
  List<dynamic>? koiList;
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
          auctionDetails = response.data;
          isLoading = false;
        });

        // Fetch koi list for the auction
        fetchKoiList();
      } else {
        setState(() {
          isLoading = false;
          auctionDetails = null;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        auctionDetails = null;
      });
    }
  }

  Future<void> fetchKoiList() async {
    try {
      final response =
          await dio.get("$auctionKoiEndpoint/auction/${widget.auctionId}");

      if (response.statusCode == 200) {
        List<dynamic> auctionKoiList = response.data;

        // Fetch detailed koi info for each koi using the koi_id
        List<Map<String, dynamic>> detailedKoiList = await Future.wait(
          auctionKoiList.map((koi) async {
            final koiDetailResponse =
                await dio.get("$koiEndpoint/${koi['koi_id']}");
            if (koiDetailResponse.statusCode == 200) {
              return <String, dynamic>{
                ...koi as Map<String, dynamic>,
                // Cast to Map<String, dynamic>
                ...koiDetailResponse.data as Map<String, dynamic>,
                // Cast to Map<String, dynamic>
              };
            }
            return koi as Map<String,
                dynamic>; // If detail API fails, return the original koi auction data as Map<String, dynamic>
          }).toList(),
        );

        setState(() {
          koiList = detailedKoiList;
        });
      } else {
        setState(() {
          koiList = [];
        });
      }
    } catch (e) {
      setState(() {
        koiList = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Auction Detail'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context); // Navigate back to AuctionListPage
            },
          ),
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (auctionDetails == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Auction Detail'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context); // Navigate back to AuctionListPage
            },
          ),
        ),
        body: Center(child: Text('No auction details available')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(auctionDetails!['title']),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back to AuctionListPage
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Status: ${getAuctionStatus(auctionDetails!['start_time'], auctionDetails!['end_time'])}', style: const TextStyle(fontSize: 16)),

            const SizedBox(height: 20), // Add space before the grid

            // Display the koi list in a grid
            Expanded(
              child: koiList != null && koiList!.isNotEmpty
                  ? GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.5,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: koiList!.length,
                      itemBuilder: (context, index) {
                        final koi = koiList![index];
                        return GestureDetector(
                          onTap: () {
                            // Navigate to the KoiDetailPage when the koi is tapped
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    KoiDetailPage(koiId: koi['koi_id']),
                              ),
                            );
                          },
                          child: Card(
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Koi Thumbnail
                                Expanded(
                                  flex: 3,
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF1365B4),
                                      // Set background color to #F1F1F1
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(10)),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.vertical(
                                          top: Radius.circular(10)),
                                      child: Image.network(
                                        koi['thumbnail'] ?? '',
                                        width: double.infinity,
                                        height: double.infinity,
                                        fit: BoxFit.contain,
                                        // Changed to contain to show full image
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Icon(Icons.image_not_supported,
                                              color: Colors.grey[400]);
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                // Koi Information
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          koi['name'] ?? 'Unknown',
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 2),
                                        Row(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Colors.green,
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                formatCurrency(koi['base_price']
                                                    ?.toDouble()),
                                                style: const TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.white),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  : const Text('No koi available for this auction'),
            ),
          ],
        ),
      ),
    );
  }
}
