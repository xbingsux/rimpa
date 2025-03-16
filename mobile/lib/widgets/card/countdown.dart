import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rimpa/core/constant/app.constant.dart';

class CountdownTimer extends StatefulWidget {
  final DateTime targetDateTime;

  const CountdownTimer({Key? key, required this.targetDateTime}) : super(key: key);

  @override
  _CountdownTimerState createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late Timer _timer;
  late Duration _timeRemaining;
  late DateTime targetTime;

  @override
  void initState() {
    super.initState();
    targetTime = widget.targetDateTime;
    _updateTimeRemaining();
    _startCountdown();
  }

  void _updateTimeRemaining() {
    final now = DateTime.now();
    setState(() {
      _timeRemaining = targetTime.difference(now).isNegative ? Duration.zero : targetTime.difference(now);
    });
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateTimeRemaining();
      if (_timeRemaining == Duration.zero) {
        _timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Widget _formatDuration(Duration duration) {
    final days = duration.inDays.toString().padLeft(2, '0');
    final hours = (duration.inHours % 24).toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');

    return Text(
      "${minutes}:${seconds}",
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontSize: 16,
            color: AppTextColors.danger,
            fontWeight: FontWeight.w500,
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 0.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.transparent, // สีพื้นหลัง
          borderRadius: BorderRadius.circular(5), // มุมโค้ง 30
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _formatDuration(_timeRemaining),
          ],
        ),
      ),
    );
  }
}
