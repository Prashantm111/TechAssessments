import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:techassesment/common/bloc/app_bloc.dart';
import 'package:techassesment/main.dart';
import 'package:techassesment/resource/Color.dart';
import 'package:techassesment/screens/home/HomeScreen.dart';
import 'package:techassesment/utils/AppWidgets.dart';

import '../../utils/AppLocalizations.dart';
import '../../utils/translation_datasource.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    return BlocConsumer<AppBloc, AppState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppToolBar(
            toolbarTittle: LocaleTexts.login_screen.tr(context),
          ),
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
                        Text(
                          LocaleTexts.welcome_to.tr(context),
                          style: TextStyle(
                              color: ColorSelect.primaryColor,
                              fontSize: 40,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        SvgPicture.asset(
                          'assets/images/company_logo.svg',
                          semanticsLabel: 'My SVG Image',

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
                        Text(
                          LocaleTexts.please_continue_as.tr(context),
                          style: TextStyle(color: Colors.black45, fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        MyButton(
                            title:   LocaleTexts.verified_user.tr(context),
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
                        MyButton(
                            title:  LocaleTexts.non_verified_user.tr(context),
                            callback: () {
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
