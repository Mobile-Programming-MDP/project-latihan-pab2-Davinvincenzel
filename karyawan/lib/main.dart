import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:karyawan/models/karyawan.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Daftar Karyawan",
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});
  
  Future<List<Karyawan>> _readJsonData() async {
    String response = await rootBundle.loadString("assets/karyawan.json");
    final List<dynamic> data = json.decode(response);
    return data.map((json) => Karyawan.fromJson(json)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Daftar Karyawan"),
      ),
      body: FutureBuilder<List<Karyawan>>(
        future: _readJsonData(),
        builder: (context, snapshot) {
          return const FallingLoadingIndicator();
        }
      ),
    );
  }
}

class FallingLoadingIndicator extends StatefulWidget {
  const FallingLoadingIndicator({super.key});

  @override
  State<FallingLoadingIndicator> createState() => _FallingLoadingIndicatorState();
}

class _FallingLoadingIndicatorState extends State<FallingLoadingIndicator> {
  double _topPosition = 0;
  bool _isFalling = false;

  void _startFalling() {
    setState(() {
      _isFalling = true;
      _topPosition = MediaQuery.of(context).size.height - 100; // Falls to bottom
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 1000),
          curve: Curves.bounceOut,
          margin: EdgeInsets.only(top: _topPosition),
          child: Center(
            child: GestureDetector(
              onTap: _startFalling,
              child: const CircularProgressIndicator(),
            ),
          ),
        ),
      ],
    );
  }
}