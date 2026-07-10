import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'models.dart';

class DataGate extends StatelessWidget {
  const DataGate({super.key, required this.child});

  final Widget child;

  Future<CineData> _load() async {
    final appRaw = await rootBundle.loadString('assets/data/cinego_data.json');
    final moviesRaw = await rootBundle.loadString('assets/data/movies.json');
    final authRaw = await rootBundle.loadString('assets/data/auth.json');
    final cinemaTypesRaw = await rootBundle.loadString(
      'assets/data/cinema_types.json',
    );
    return CineData.fromJson(
      jsonDecode(appRaw) as Map<String, dynamic>,
      jsonDecode(moviesRaw) as Map<String, dynamic>,
      jsonDecode(authRaw) as Map<String, dynamic>,
      jsonDecode(cinemaTypesRaw) as Map<String, dynamic>,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CineData>(
      future: _load(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return AppScope(data: snapshot.data!, child: child);
        }
        return const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(body: Center(child: CircularProgressIndicator())),
        );
      },
    );
  }
}

class AppScope extends InheritedWidget {
  const AppScope({super.key, required this.data, required super.child});

  final CineData data;

  static CineData of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppScope>()!.data;
  }

  @override
  bool updateShouldNotify(AppScope oldWidget) => data != oldWidget.data;
}
