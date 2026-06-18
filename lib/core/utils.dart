import 'package:flutter/cupertino.dart';

/// timeAgo computes relative time descriptions from a DateTime input.
String timeAgo(DateTime dateTime) {
  final now = DateTime.now().toUtc();
  final difference = now.difference(dateTime);
  if (difference.isNegative || difference.inSeconds < 5) {
    return 'Just now';
  } else if (difference.inMinutes < 60) {
    return '${difference.inMinutes} mins ago';
  } else if (difference.inHours < 24) {
    final hours = difference.inHours;
    final minutes = difference.inMinutes % 60;
    return minutes == 0 ? '$hours hrs ago' : '$hours hr ${minutes}m ago';
  } else {
    return '${difference.inDays} days ago';
  }
}

/// Responsive utility to scale sizing based on screen dimensions.
class Responsive {
  Responsive._();

  /// Gets the screen width percentage.
  static double width(BuildContext context, double percentage) {
    return MediaQuery.sizeOf(context).width * (percentage / 100);
  }

  /// Gets the screen height percentage.
  static double height(BuildContext context, double percentage) {
    return MediaQuery.sizeOf(context).height * (percentage / 100);
  }

  /// Scales a baseline layout size to match the screen's aspect ratio.
  static double scale(BuildContext context, double size) {
    final width = MediaQuery.sizeOf(context).width;
    // Clamp to prevent layout distortion on large tablets or tiny screens
    final scaleFactor = (width / 390.0).clamp(0.85, 1.15);
    return size * scaleFactor;
  }

  /// Scales text size specifically with tighter constraints to keep typography readable.
  static double scaleText(BuildContext context, double size) {
    final width = MediaQuery.sizeOf(context).width;
    final scaleFactor = (width / 390.0).clamp(0.9, 1.1);
    return size * scaleFactor;
  }
}

/// Format a DateTime to a clean readable string: e.g. "Jun 16, 2026"
String formatDate(DateTime dt) {
  final local = dt.toLocal();
  const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  return '${months[local.month - 1]} ${local.day}, ${local.year}';
}
