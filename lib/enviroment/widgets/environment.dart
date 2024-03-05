import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:inventory_prototype/enviroment/environment_manager.dart';

class Environment extends StatefulWidget {
  final EnvironmentManager manager;

  const Environment({
    required this.manager,
    super.key,
  });

  @override
  State<Environment> createState() => _EnvironmentState();
}

class _EnvironmentState extends State<Environment> {
  int _frameCallbackId = 0;
  Duration? lastTimestamp;

  @override
  void initState() {
    super.initState();
    widget.manager.init();
    _scheduleTick();
  }

  void _scheduleTick({bool rescheduling = false}) {
    _frameCallbackId = SchedulerBinding.instance.scheduleFrameCallback(_tick, rescheduling: rescheduling);
  }

  void _unscheduleTick() {
    SchedulerBinding.instance.cancelFrameCallbackWithId(_frameCallbackId);
  }

  @override
  void dispose() {
    _unscheduleTick();
    super.dispose();
  }

  void _tick(Duration timestamp) {
    final Duration deltaTime = timestamp - (lastTimestamp ?? timestamp);
    lastTimestamp = timestamp;

    widget.manager.update(deltaTime.inMicroseconds.toDouble() / Duration.microsecondsPerSecond);

    setState(() {});

    _scheduleTick(rescheduling: true);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.manager.settings.size.width,
      height: widget.manager.settings.size.height,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
          width: 2,
        ),
      ),
      child: Stack(
        children: widget.manager.build(context),
      ),
    );
  }
}
