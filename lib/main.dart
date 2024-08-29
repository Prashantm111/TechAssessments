import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:techassesment/Color.dart';
import 'package:techassesment/common/bloc/app_bloc.dart';
import 'package:techassesment/data/UserInfoModel.dart';
import 'package:techassesment/screens/home/HomeScreen.dart';
import 'package:techassesment/screens/TopUpScreen.dart';
import 'package:techassesment/screens/login_screen.dart';
import 'package:techassesment/services/database_helper.dart';
import 'package:techassesment/utils/AppWidgets.dart';

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

/*class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List<UserInfoModel> totalUsers = [];



  @override
  void initState() {
    refreshNotes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery
        .of(context)
        .orientation;
    DatabaseHelper noteDatabase = DatabaseHelper.instance;
    return Scaffold(
      appBar: AppToolBar(toolbarTittle: widget.title),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Flex(
          crossAxisAlignment: CrossAxisAlignment.center,
          direction: orientation == Orientation.portrait
              ? Axis.vertical
              : Axis.horizontal,
          children: <Widget>[
            Column(
              children: [
                const SizedBox(height: 50),
                const Text(
                  "Welcome to",
                  style: TextStyle(
                      color: ColorSelect.primaryColor,
                      fontSize: 40,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SvgPicture.asset(
                  'assets/images/company_logo.svg',
                  semanticsLabel: 'My SVG Image',
                  colorFilter: const ColorFilter.mode(
                      ColorSelect.primaryColor, BlendMode.srcIn),
                  height: 100,
                  width: 70,
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Please continue as...",
                  style: TextStyle(color: Colors.black45, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 5,
                ),
                MyButton(
                    title: "Verified User",
                    callback: () {
                      Navigator.of(context).pushNamed(
                        HomeScreen.routeName,
                        arguments: totalUsers.elementAt(0),
                      );
                    }),
                const SizedBox(
                  height: 10,
                ),
                MyButton(
                    title: "Non Verified User",
                    callback: () {
                      Navigator.of(context).pushNamed(
                        HomeScreen.routeName,
                        arguments: totalUsers.elementAt(1),
                      );
                    })
              ],
            ),
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}*/
