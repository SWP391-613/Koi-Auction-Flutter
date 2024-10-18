import 'package:intl/intl.dart';

String formatCurrency(double? amount, {String currency = '\$', String locale = 'en_US'}) {
  if (amount == null) return ''; // Return an empty string for null values

  // Create a NumberFormat instance with the desired locale and currency
  NumberFormat format = NumberFormat.currency(
    name: currency,
    locale: locale,
    decimalDigits: 0, // No decimal places
  );

  return format.format(amount);
}