String sanitizeText(String input) {
  final sanitized = input
      .replaceAll(RegExp(r'<[^>]*>'), '') // إزالة أي HTML
      .replaceAll(RegExp(r'script', caseSensitive: false), '')
      .trim();
  return sanitized;
}
bool containsDangerousContent(String text) {
  final htmlTag = RegExp(r'<[^>]+>');
  final scriptWord = RegExp(r'script', caseSensitive: false);
  return htmlTag.hasMatch(text) || scriptWord.hasMatch(text);
}

String formatTime(DateTime date) {
  final difference = DateTime.now().difference(date);

  if (difference.inMinutes < 1) {
    return "منذ دقيقة";
  } else if (difference.inMinutes < 60) {
    return "منذ ${difference.inMinutes} دقيقة";
  } else if (difference.inHours < 24) {
    return "منذ ${difference.inHours} ساعة";
  } else if (difference.inDays < 7) {
    return "منذ ${difference.inDays} يوم";
  } else {
    return "${date.day}/${date.month}/${date.year}";
  }
}
