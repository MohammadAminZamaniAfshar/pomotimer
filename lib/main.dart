import 'package:flutter/material.dart';
import 'package:pomotimer/bindings/initial_bindings.dart';
import 'package:pomotimer/pomotimer_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await InitialBindings().dependencies();
  runApp(const PomoTimerApp());
}
