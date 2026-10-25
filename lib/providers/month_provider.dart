import 'package:flutter_riverpod/legacy.dart';

class MonthNotifier extends StateNotifier<DateTime> {
  MonthNotifier() : super(DateTime.now());

  void next() {
    state = DateTime(state.year, state.month + 1, 1);
  }

  void previous() {
    state = DateTime(state.year, state.month - 1, 1);
  }

  void goToNow() {
    state = DateTime.now();
  }

  String get label {
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    return '${months[state.month - 1]} ${state.year}';
  }

  bool isSameMonth(DateTime other) {
    return state.year == other.year && state.month == other.month;
  }
}

final monthProvider =
StateNotifierProvider<MonthNotifier, DateTime>((ref) => MonthNotifier());