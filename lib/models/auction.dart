class Auction {
  final int id;
  final String title;
  final String startTime;
  final String endTime;
  final String status;
  final int auctioneerId;

  Auction({
    required this.id,
    required this.title,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.auctioneerId,
  });

  // Factory method to create an Auction instance from a JSON object
  factory Auction.fromJson(Map<String, dynamic> json) {
    return Auction(
      id: json['id'],
      title: json['title'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      status: json['status'],
      auctioneerId: json['auctioneer_id'],
    );
  }
}
