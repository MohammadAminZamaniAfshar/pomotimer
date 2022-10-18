import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'constant.dart';
import 'enum.dart';

class CircleAnimatedButtonController extends GetxController with GetSingleTickerProviderStateMixin {
  CircleAnimatedButtonController({
    CircleAnimatedButtonStatus status = CircleAnimatedButtonStatus.finished,
  }) : _circleButtonStatus = status;

  late final AnimationController _animationController;
  late final Animation<Alignment> animationLeft;
  late final Animation<Alignment> animationRight;

  CircleAnimatedButtonStatus _circleButtonStatus;

  // When [inProgress] is true button does not respond to user tap
  bool inProgress = false;
  double _turns = 0.0;

  bool get showPlayIcon => isFinished ? true : isPaused;
  bool get isStarted => _circleButtonStatus.isStarted;
  bool get isPaused => _circleButtonStatus.isPaused;
  bool get isResumed => _circleButtonStatus.isResumed;
  bool get isFinished => _circleButtonStatus.isFinished;
  double get turns => _turns;

  @override
  void onInit() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _animationController.addListener(
      () => update([kCancelButton_getbuilderKey, kRestartButton_getbuilderKey]),
    );

    animationLeft = _animationController.drive(
      AlignmentTween(
        begin: Alignment.center,
        end: Alignment.centerLeft,
      ),
    );
    animationRight = _animationController.drive(
      AlignmentTween(
        begin: Alignment.center,
        end: Alignment.centerRight,
      ),
    );
    if (!isFinished) {
      _animationController.value = 1.0;
    }

    super.onInit();
  }

  @override
  void onClose() {
    _animationController.dispose();
    super.onClose();
  }

  Future<void> startAnimation() async {
    _circleButtonStatus = CircleAnimatedButtonStatus.started;
    update([kMainButton_getbuilderKey]);
    await _startAnimations();
  }

  void restartAnimation() {
    _circleButtonStatus = CircleAnimatedButtonStatus.started;
    _turns += 1;
    update([kRestartButton_getbuilderKey, kMainButton_getbuilderKey]);
  }

  void pauseAnimation() {
    _circleButtonStatus = CircleAnimatedButtonStatus.pause;
    update([kMainButton_getbuilderKey]);
  }

  void resumeAnimation() {
    _circleButtonStatus = CircleAnimatedButtonStatus.resumed;
    update([kMainButton_getbuilderKey]);
  }

  Future<void> finishAnimation() async {
    _circleButtonStatus = CircleAnimatedButtonStatus.finished;
    update([kMainButton_getbuilderKey]);
    await _startAnimations();
  }

  Future<void> _startAnimations() async {
    inProgress = true;
    if (isFinished) {
      await _animationController.reverse();
    } else {
      await _animationController.forward();
    }
    inProgress = false;
  }
}
