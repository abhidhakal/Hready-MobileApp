import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hready/core/widgets/app_snackbar.dart';

// String Extensions
extension StringExtension on String {
  bool get isNullOrEmpty => isEmpty;
  bool get isNotNullOrEmpty => isNotEmpty;

  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  String get titleCase {
    if (isEmpty) return this;
    return split(' ').map((word) => word.capitalize).join(' ');
  }

  String get camelCase {
    if (isEmpty) return this;
    return split(' ').map((word) => word.capitalize).join('');
  }

  String get snakeCase {
    if (isEmpty) return this;
    return toLowerCase().replaceAll(' ', '_');
  }

  String get kebabCase {
    if (isEmpty) return this;
    return toLowerCase().replaceAll(' ', '-');
  }

  String truncate(int maxLength, {String suffix = '...'}) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength)}$suffix';
  }

  String get initials {
    if (isEmpty) return '';
    final words = split(' ');
    if (words.length == 1) return words[0][0].toUpperCase();
    return '${words[0][0]}${words[1][0]}'.toUpperCase();
  }

  bool get isValidEmail {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(this);
  }

  bool get isValidPhone {
    final phoneRegex = RegExp(r'^\+?[\d\s-()]{10,}$');
    return phoneRegex.hasMatch(this);
  }

  bool get isValidUrl {
    try {
      Uri.parse(this);
      return true;
    } catch (e) {
      return false;
    }
  }
}

// DateTime Extensions
extension DateTimeExtension on DateTime {
  String get formattedDate => DateFormat('dd MMM yyyy').format(this);
  String get formattedTime => DateFormat('HH:mm').format(this);
  String get formattedDateTime => DateFormat('dd MMM yyyy HH:mm').format(this);
  String get formattedDateShort => DateFormat('dd/MM/yyyy').format(this);
  String get formattedTimeShort => DateFormat('HH:mm:ss').format(this);

  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year && month == yesterday.month && day == yesterday.day;
  }

  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return year == tomorrow.year && month == tomorrow.month && day == tomorrow.day;
  }

  bool get isThisWeek {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    return isAfter(startOfWeek) && isBefore(endOfWeek);
  }

  bool get isThisMonth {
    final now = DateTime.now();
    return year == now.year && month == now.month;
  }

  bool get isThisYear {
    return year == DateTime.now().year;
  }

  DateTime get startOfDay => DateTime(year, month, day);
  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59);
  DateTime get startOfWeek => subtract(Duration(days: weekday - 1));
  DateTime get endOfWeek => startOfWeek.add(const Duration(days: 6));
  DateTime get startOfMonth => DateTime(year, month, 1);
  DateTime get endOfMonth => DateTime(year, month + 1, 0);

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} year${(difference.inDays / 365).floor() == 1 ? '' : 's'} ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} month${(difference.inDays / 30).floor() == 1 ? '' : 's'} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else {
      return 'Just now';
    }
  }
}

// Number Extensions
extension NumberExtension on num {
  String get currency => 'Rs. ${toStringAsFixed(2)}';
  String get percentage => '${toStringAsFixed(1)}%';
  String get compact => _compactNumber(this);

  String _compactNumber(num number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }

  Duration get milliseconds => Duration(milliseconds: toInt());
  Duration get seconds => Duration(seconds: toInt());
  Duration get minutes => Duration(minutes: toInt());
  Duration get hours => Duration(hours: toInt());
  Duration get days => Duration(days: toInt());
}

// BuildContext Extensions
extension BuildContextExtension on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  Size get screenSize => MediaQuery.of(this).size;
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
  double get statusBarHeight => MediaQuery.of(this).padding.top;
  double get bottomPadding => MediaQuery.of(this).padding.bottom;
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
  bool get isLightMode => Theme.of(this).brightness == Brightness.light;

  void showSnackBar(String message, {Duration? duration}) {
    AppSnackbar.info(this, message, duration: duration);
  }

  void showErrorSnackBar(String message, {Duration? duration}) {
    AppSnackbar.error(this, message, duration: duration);
  }

  void showSuccessSnackBar(String message, {Duration? duration}) {
    AppSnackbar.success(this, message, duration: duration);
  }

  void showWarningSnackBar(String message, {Duration? duration}) {
    AppSnackbar.warning(this, message, duration: duration);
  }

  Future<T?> showCustomDialog<T>({
    required Widget child,
    bool barrierDismissible = true,
  }) {
    return showDialog<T>(
      context: this,
      barrierDismissible: barrierDismissible,
      builder: (context) => child,
    );
  }

  void pop<T>([T? result]) {
    Navigator.of(this).pop(result);
  }

  Future<T?> pushNamed<T>(String routeName, {Object? arguments}) {
    return Navigator.of(this).pushNamed<T>(routeName, arguments: arguments);
  }

  Future<T?> pushReplacementNamed<T>(String routeName, {Object? arguments}) {
    return Navigator.of(this).pushReplacementNamed<T, void>(routeName, arguments: arguments);
  }

  void pushNamedAndRemoveUntil(String routeName, {Object? arguments}) {
    Navigator.of(this).pushNamedAndRemoveUntil(
      routeName,
      (route) => false,
      arguments: arguments,
    );
  }
}

// List Extensions
extension ListExtension<T> on List<T> {
  bool get isNullOrEmpty => isEmpty;
  bool get isNotNullOrEmpty => isNotEmpty;

  List<T> get unique => toSet().toList();

  List<T> get reversed => List.from(this.reversed);

  T? get firstOrNull => isEmpty ? null : first;
  T? get lastOrNull => isEmpty ? null : last;

  List<T> takeFirst(int count) {
    if (count >= length) return this;
    return sublist(0, count);
  }

  List<T> takeLast(int count) {
    if (count >= length) return this;
    return sublist(length - count);
  }

  List<T> whereNotNull() {
    return where((element) => element != null).cast<T>().toList();
  }

  List<T> addIf(bool condition, T element) {
    if (condition) {
      add(element);
    }
    return this;
  }

  List<T> addAllIf(bool condition, Iterable<T> elements) {
    if (condition) {
      addAll(elements);
    }
    return this;
  }
}

// Map Extensions
extension MapExtension<K, V> on Map<K, V> {
  bool get isNullOrEmpty => isEmpty;
  bool get isNotNullOrEmpty => isNotEmpty;

  Map<K, V> get reversed => Map.fromEntries(entries.toList().reversed);

  V? getOrNull(K key) => containsKey(key) ? this[key] : null;

  Map<K, V> addIf(bool condition, K key, V value) {
    if (condition) {
      this[key] = value;
    }
    return this;
  }

  Map<K, V> removeIf(bool condition, K key) {
    if (condition && containsKey(key)) {
      remove(key);
    }
    return this;
  }

  Map<K, V> whereKeys(bool Function(K key) test) {
    return Map.fromEntries(entries.where((entry) => test(entry.key)));
  }

  Map<K, V> whereValues(bool Function(V value) test) {
    return Map.fromEntries(entries.where((entry) => test(entry.value)));
  }
} 