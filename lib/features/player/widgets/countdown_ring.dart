import 'dart:math';

import 'package:flutter/material.dart';

import '../../../core/player/player_phase.dart';

class CountdownRing extends StatefulWidget {
  const CountdownRing({
    super.key,
    required this.phase,
    required this.remainingSeconds,
    required this.totalSeconds,
    required this.isCountingUp,
    this.size = 220,
    this.stroke = 10,
  });

  final PlayerPhase phase;
  final int remainingSeconds;
  final int totalSeconds;
  final bool isCountingUp;
  final double size;
  final double stroke;

  @override
  State<CountdownRing> createState() => _CountdownRingState();
}

class _CountdownRingState extends State<CountdownRing>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _controller.value = _computeProgress();
  }

  @override
  void didUpdateWidget(CountdownRing old) {
    super.didUpdateWidget(old);
    if (old.remainingSeconds != widget.remainingSeconds ||
        old.phase != widget.phase) {
      _controller.animateTo(
        _computeProgress(),
        duration: const Duration(milliseconds: 900),
        curve: Curves.linear,
      );
    }
  }

  double _computeProgress() {
    switch (widget.phase) {
      case PlayerPhase.countdown:
        return widget.totalSeconds > 0
            ? widget.remainingSeconds / widget.totalSeconds
            : 1.0;
      case PlayerPhase.complete:
        return 1.0;
      default:
        if (widget.isCountingUp || widget.totalSeconds == 0) {
          return widget.remainingSeconds == 0
              ? 0
              : (widget.remainingSeconds % 30) / 30.0;
        }
        return widget.totalSeconds > 0
            ? widget.remainingSeconds / widget.totalSeconds
            : 0;
    }
  }

  Color get _ringColor {
    switch (widget.phase) {
      case PlayerPhase.countdown:
      case PlayerPhase.complete:
        return const Color(0xFF4CAF50);
      case PlayerPhase.working:
        return const Color(0xFFE84040);
      case PlayerPhase.resting:
        return const Color(0xFFF5A623);
      case PlayerPhase.idle:
        return const Color(0xFF555555);
    }
  }

  String get _label {
    switch (widget.phase) {
      case PlayerPhase.working:
        return widget.isCountingUp ? 'ELAPSED' : 'REMAINING';
      case PlayerPhase.resting:
        return 'REMAINING';
      default:
        return '';
    }
  }

  String _fmt(int secs) {
    final m = secs ~/ 60;
    final s = secs % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  String get _displayValue {
    if (widget.phase == PlayerPhase.countdown) {
      return widget.remainingSeconds.toString();
    }
    return _fmt(widget.remainingSeconds);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final valueStyle = TextStyle(
      fontFamily: 'RobotoMono',
      fontSize: widget.size * 0.28,
      fontWeight: FontWeight.w700,
      color: Colors.white,
      letterSpacing: -1,
    );
    const labelStyle = TextStyle(
      fontSize: 10,
      color: Color(0xFF9E9E9E),
      letterSpacing: 1.6,
    );

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) => SizedBox(
        width: widget.size,
        height: widget.size,
        child: CustomPaint(
          painter: _RingPainter(
            progress: _controller.value,
            color: _ringColor,
            stroke: widget.stroke,
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_label.isNotEmpty) Text(_label, style: labelStyle),
                Text(_displayValue, style: valueStyle),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  const _RingPainter({
    required this.progress,
    required this.color,
    required this.stroke,
  });

  final double progress;
  final Color color;
  final double stroke;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - stroke) / 2;

    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = const Color(0xFF1F1F1F)
        ..strokeWidth = stroke
        ..style = PaintingStyle.stroke,
    );

    if (progress > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -pi / 2,
        2 * pi * progress,
        false,
        Paint()
          ..color = color
          ..strokeWidth = stroke
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round,
      );
    }
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.progress != progress || old.color != color;
}
