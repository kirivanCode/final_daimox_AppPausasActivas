import 'dart:async';
import 'package:flutter/material.dart';

class ExerciseTimer extends StatefulWidget {
  final int duration;
  final VoidCallback onTimerEnd;
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final bool autoRestart;
  final bool isRunning;

  const ExerciseTimer({
    required this.duration,
    required this.onTimerEnd,
    required this.onNext,
    required this.onPrevious,
    this.autoRestart = false,
    this.isRunning = false,
    super.key,
  });

  @override
  State<ExerciseTimer> createState() => _ExerciseTimerState();
}

class _ExerciseTimerState extends State<ExerciseTimer> {
  late int _seconds;
  late bool _isRunning;
  Timer? _timer;

  int _selectedMinutes = 0;
  int _selectedSeconds = 0;

  List<int> _minuteOptions = List.generate(60, (index) => index);
  List<int> _secondOptions = List.generate(60, (index) => index);

  @override
  void initState() {
    super.initState();
    _seconds = widget.duration;
    _isRunning = widget.isRunning;
    if (_isRunning) {
      _startTimer();
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_seconds == 0) {
        timer.cancel();
        _isRunning = false;
        widget.onTimerEnd();
        if (widget.autoRestart) {
          _restartTimer();
        }
      } else if (_isRunning) {
        setState(() {
          _seconds--;
        });
      }
    });
  }

  void _pauseOrResume() {
    setState(() {
      _isRunning = !_isRunning;
      if (_isRunning) {
        _startTimer();
      } else {
        _timer?.cancel();
      }
    });
  }

  void _reset() {
    setState(() {
      _seconds = widget.duration;
      _isRunning = false;
      _timer?.cancel();
    });
  }

  void _restartTimer() {
    _reset();
    _startTimer();
  }

  void _updateTimer() {
    setState(() {
      _seconds = _selectedMinutes * 60 + _selectedSeconds;
      _isRunning = false;
      _timer?.cancel();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int minutes = _seconds ~/ 60;
    int seconds = _seconds % 60;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, size: 40),
              onPressed: widget.onPrevious,
            ),
            const SizedBox(width: 20),
            Text(
              '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
              style: const TextStyle(fontSize: 40),
            ),
            const SizedBox(width: 20),
            IconButton(
              icon: const Icon(Icons.arrow_forward, size: 40),
              onPressed: widget.onNext,
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButton<int>(
              value: _selectedMinutes,
              items: _minuteOptions
                  .map((minute) => DropdownMenuItem<int>(
                        value: minute,
                        child: Text('$minute min'),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedMinutes = value;
                  });
                }
              },
            ),
            const SizedBox(width: 10),
            DropdownButton<int>(
              value: _selectedSeconds,
              items: _secondOptions
                  .map((second) => DropdownMenuItem<int>(
                        value: second,
                        child: Text('$second sec'),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedSeconds = value;
                  });
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.check, size: 40),
              onPressed: _updateTimer,
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(_isRunning ? Icons.pause : Icons.play_arrow, size: 40),
              onPressed: _pauseOrResume,
            ),
            const SizedBox(width: 20),
            IconButton(
              icon: const Icon(Icons.replay, size: 40),
              onPressed: _reset,
            ),
          ],
        ),
      ],
    );
  }
}
