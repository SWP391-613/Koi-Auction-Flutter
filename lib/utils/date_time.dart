String getAuctionStatus(String startTime, String endTime) {
  print('Data received: $startTime - $endTime');

  final now = DateTime.now();

  // Parse the start and end times
  final start = DateTime.parse(startTime);
  final end = DateTime.parse(endTime);

  // Check for invalid dates
  if (start.isBefore(DateTime(1970)) || end.isBefore(DateTime(1970))) {
    return 'Invalid date'; // Handle invalid date parsing
  }

  // If the current time is before the start time
  if (now.isBefore(start)) {
    return 'Not started yet';
  }
  // If the auction is ongoing
  else if (now.isAfter(start) && now.isBefore(end)) {
    return 'Ongoing';
  }
  // If the auction has ended
  else {
    final diffTime = now.difference(end);
    final diffDays = diffTime.inDays;

    if (diffDays < 1) {
      return 'Ended today';
    } else if (diffDays < 30) {
      return 'Ended $diffDays day${diffDays > 1 ? 's' : ''} ago';
    } else if (diffDays < 365) {
      final diffMonths = (diffDays / 30).floor();
      return 'Ended $diffMonths month${diffMonths > 1 ? 's' : ''} ago';
    } else {
      final diffYears = (diffDays / 365).floor();
      return 'Ended $diffYears year${diffYears > 1 ? 's' : ''} ago';
    }
  }
}
