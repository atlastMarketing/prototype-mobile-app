DateTime roundDown(DateTime t, {Duration delta = const Duration(seconds: 15)}) {
  return DateTime.fromMillisecondsSinceEpoch(t.millisecondsSinceEpoch -
      t.millisecondsSinceEpoch % delta.inMilliseconds);
}
