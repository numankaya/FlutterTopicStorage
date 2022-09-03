import 'package:flutter/material.dart';
import 'package:storage/shared_pref_kullanimi.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: SharedPreferenceKullanimi(),
    );
  }
}
