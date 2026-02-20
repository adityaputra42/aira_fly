import 'dart:async';
import 'dart:ui';

class DebouncerHelper {
  final int milliseconds;
  Timer? _timer;

  DebouncerHelper({required this.milliseconds});

  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
