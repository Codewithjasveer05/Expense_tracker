import 'package:intl/intl.dart';

class Formatters {
  static final NumberFormat _money = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 2,
  );

  static final NumberFormat _compact = NumberFormat.compact();

  static String money(double value) => _money.format(value);

  static String compact(double value) => _compact.format(value);

  static String monthYear(DateTime date) =>
      DateFormat('MMMM yyyy').format(date);

  static String shortMonth(DateTime date) => DateFormat('MMM').format(date);

  static String day(DateTime date) => DateFormat('d MMM, yyyy').format(date);
}