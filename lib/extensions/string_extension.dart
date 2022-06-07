extension StringExtension on String? {
  String extractNumbers() {
    if (this == null || this!.isEmpty) return "";
    return RegExp(r'(\d+)').allMatches(this!).map((m) => m.group(0)).join('');
  }

  int? toColor() {
    return int.tryParse("0xFF$this");
  }
}