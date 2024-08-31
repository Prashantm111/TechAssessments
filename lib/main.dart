import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:techassesment/common/bloc/app_bloc.dart';
import 'package:techassesment/screens/home/HomeScreen.dart';
import 'package:techassesment/screens/registration/LoginScreen.dart';
import 'package:techassesment/screens/topup/TopUpScreen.dart';
import 'package:techassesment/services/database_helper.dart';
import 'package:techassesment/utils/AppLocalizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});


  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<DatabaseHelper>(
      create: (context) => DatabaseHelper.instance,
      child: BlocProvider<AppBloc>(
        create: (context) => AppBloc(DatabaseHelper.instance),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          supportedLocales: const [
            Locale('en'),
            Locale('ar'),
          ],
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          localeResolutionCallback: (deviceLocale, supportedLocales) {
            for (var locale in supportedLocales) {
              if (deviceLocale != null &&
                  deviceLocale.languageCode == locale.languageCode) {
                return deviceLocale;
              }
            }
            return supportedLocales.first;
          },
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

extension TranslateWhoutArgs on String {
  String tr(BuildContext context) {
    return AppLocalizations.of(context)!.translate(this);
  }
}
