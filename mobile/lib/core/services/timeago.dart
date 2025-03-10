String timeAgoCustom(DateTime dateTime) {
  final Duration diff = DateTime.now().difference(dateTime);

  if (diff.inSeconds < 60) {
    return '${diff.inSeconds} วินาทีที่แล้ว';
  } else if (diff.inMinutes < 60) {
    return '${diff.inMinutes} นาทีที่แล้ว';
  } else if (diff.inHours < 24) {
    return '${diff.inHours} ชั่วโมงที่แล้ว';
  } else if (diff.inDays < 30) {
    return '${diff.inDays} วันที่แล้ว';
  } else if (diff.inDays < 365) {
    return '${(diff.inDays / 30).floor()} เดือนที่แล้ว';
  } else {
    return '${(diff.inDays / 365).floor()} ปีที่แล้ว';
  }
}
