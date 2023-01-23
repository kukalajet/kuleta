extension DateTimeX on DateTime {
  bool inTheFuture() {
    final now = DateTime.now();
    return difference(now).inMinutes > 1;
  }
}
