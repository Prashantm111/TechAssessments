import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:techassesment/common/bloc/app_bloc.dart';
import 'package:techassesment/screens/home/HomeScreen.dart';
import 'package:techassesment/screens/registration/LoginScreen.dart';
import 'package:techassesment/screens/topup/TopUpScreen.dart';
import 'package:techassesment/services/database_helper.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<DatabaseHelper>(
      create: (context) => DatabaseHelper.instance,
      child: BlocProvider<AppBloc>(
        create: (context) => AppBloc(DatabaseHelper.instance),
        child: MaterialApp(
          routes: {
            HomeScreen.routeName: (ctx) => const HomeScreen(),
            TopUpScreen.routeName: (ctx) => const TopUpScreen()
          },
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const LoginScreen(),
        ),
      ),
    );
  }
}
