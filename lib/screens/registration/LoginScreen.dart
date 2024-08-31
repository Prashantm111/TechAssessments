import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:techassesment/common/bloc/app_bloc.dart';
import 'package:techassesment/resource/Color.dart';
import 'package:techassesment/screens/home/HomeScreen.dart';
import 'package:techassesment/utils/AppWidgets.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    return BlocConsumer<AppBloc, AppState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: const AppToolBar(toolbarTittle: "Login Screen"),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Stack(
              children: [
                Flex(
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
                              context
                                  .read<AppBloc>()
                                  .loginUser(true)
                                  .then((val) {
                                Navigator.of(context).pushNamed(
                                  HomeScreen.routeName,
                                );
                              });
                            }),
                        const SizedBox(
                          height: 10,
                        ),
                        MyButton(title: "Non Verified User", callback: () {
                          {
                            context
                                .read<AppBloc>()
                                .loginUser(false)
                                .then((val) {
                              Navigator.of(context).pushNamed(
                                HomeScreen.routeName,
                              );
                            });
                          }
                        })
                      ],
                    ),
                  ],
                ),
                Visibility(
                  visible: state.isLoading,
                  child: const Center(
                    child: CenterProgressLoader(
                        backgroundColor: ColorSelect.primaryColor,
                        color: Colors.green,
                        strokeWidth: 8),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
