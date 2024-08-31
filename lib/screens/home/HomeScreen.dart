import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:techassesment/common/bloc/app_bloc.dart';
import 'package:techassesment/data/UserInfo.dart';
import 'package:techassesment/main.dart';
import 'package:techassesment/screens/home/bloc/home_cubit.dart';
import 'package:techassesment/screens/topup/TopUpScreen.dart';
import 'package:techassesment/services/database_helper.dart';

import '../../data/Beneficiary.dart';
import '../../resource/Color.dart';
import '../../utils/AppLocalizations.dart';
import '../../utils/AppWidgets.dart';
import '../../utils/translation_datasource.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/home-screen';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    UserInfoModel args = BlocProvider.of<AppBloc>(context).state.userInfoModel!;

    return BlocProvider<HomeCubit>(
      create: (context) => HomeCubit(
          userId: args.id!,
          databaseHelper: RepositoryProvider.of<DatabaseHelper>(context)),
      child: HomeUi(
        userInfoModel: args,
      ),
    );
  }
}

class HomeUi extends StatelessWidget {
  final UserInfoModel userInfoModel;

  const HomeUi({super.key, required this.userInfoModel});

  @override
  Widget build(BuildContext context) {
    var addMoneyController = TextEditingController();

    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {
        if (state.selectedBeneficiary != null && !state.isLoading) {}
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppToolBar(
            toolbarTittle: LocaleTexts.home_screen.tr(context),
          ),
          body: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  Center(
                    child: UserProfileCardItem(context, userInfoModel),
                  ),
                  userCreditInfo(context, addMoneyController),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: DefaultTabController(
                        length: 2,
                        child: Container(
                          padding: const EdgeInsets.all(0),
                          height: 45,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(25.0)),
                          child: TabBar(
                            dividerColor: Colors.transparent,
                            onTap: (v) {
                              context.read<HomeCubit>().onToggleTab(v);
                            },
                            indicator: BoxDecoration(
                                color: Colors.green[300],
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    topRight: Radius.circular(8))),
                            labelColor: Colors.white,
                            unselectedLabelColor: Colors.black,
                            tabs: [
                              Container(
                                alignment: Alignment.center,
                                width: double.infinity,
                                child: Text(LocaleTexts.recharge.tr(context)),
                              ),
                              Container(
                                alignment: Alignment.center,
                                width: double.infinity,
                                child: Text(LocaleTexts.history.tr(context)),
                              ),
                            ],
                          ),
                        )),
                  ),
                  Visibility(
                      visible: state.isRechargeViewSelected,
                      child: BeneficiaryRow(state, context)),
                  Visibility(
                    visible: !state.isRechargeViewSelected,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Column(
                        children: [
                          Visibility(
                            visible: (state.rechargesList == null ||
                                state.rechargesList!.isEmpty),
                            child:
                                Text(LocaleTexts.no_recharge_done.tr(context)),
                          ),
                          ListView(
                            primary: false,
                            shrinkWrap: true,
                            children: List<Widget>.generate(
                                state.rechargesList?.length ?? 0, (int index) {
                              return historyItemCard(state, index);
                            }),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Column BeneficiaryRow(HomeState state, BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(
          height: 15,
        ),
        Visibility(
          visible:
              (state.beneficiaryList == null || state.beneficiaryList!.isEmpty),
          child: Text(LocaleTexts.no_beneficiary_ad.tr(context)),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          reverse: true,
          child: Row(
            children: List<Widget>.generate(state.beneficiaryList?.length ?? 0,
                (int index) {
              return BeneficiaryRowCard(
                beneficiary: state.beneficiaryList!.elementAt(index),
              );
            }),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Center(
          child: ElevatedButton(
            onPressed: () {
              showAddBeneficiaryDialog(context, userInfoModel.id);
            },
            child: Text(LocaleTexts.add_beneficiary.tr(context)),
          ),
        )
      ],
    );
  }

  String dtm(String dateString) {
    try {
      var dt = DateTime.fromMillisecondsSinceEpoch(int.parse(dateString));

      var date = DateFormat('dd-MMM-yyyy').format(dt);

      return date.toString();
    } catch (e) {
      return "null";
    }
  }

  Container historyItemCard(HomeState state, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
              color: Colors.grey,
              spreadRadius: 1,
              blurRadius: 8,
              offset: Offset(0, 1))
        ],

        color: Colors.white, //Border.all
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              state.rechargesList!.elementAt(index).username.toString(),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              "${state.rechargesList!.elementAt(index).credit.toString()} AED",
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
                dtm(state.rechargesList!.elementAt(index).date.toString())),
          ),
        ],
      ),
    );
  }

  Container userCreditInfo(
      BuildContext context, TextEditingController addMoneyController) {
    return Container(
      margin: const EdgeInsets.all(16),
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
              color: Colors.black12,
              spreadRadius: 3,
              blurRadius: 6,
              offset: Offset(0, 5))
        ],

        color: Colors.black, //Border.all
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                LocaleTexts.credit_balance.tr(context),
                style: TextStyle(color: Colors.white),
              ),
              Text(
                "${userInfoModel.credit}",
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: () {
              showAddMoneyDialog(context, addMoneyController);
            },
            child: Text(LocaleTexts.add_money.tr(context)),
          )
        ],
      ),
    );
  }

  Future<dynamic> showAddMoneyDialog(
      BuildContext context, TextEditingController addMoneyController) {
    return showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text(LocaleTexts.add_credit.tr(context)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextField(
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                    ],
                    controller: addMoneyController,
                    keyboardType: TextInputType.number,
                    maxLength: 5,
                    decoration: InputDecoration(
                      label: Text(LocaleTexts.enter_amount.tr(context)),
                    ),
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        elevation: 3,
                      ),
                      onPressed: () {
                        context.read<HomeCubit>().addMoneyToUser(userInfoModel,
                            double.parse(addMoneyController.text));

                        Navigator.of(context).pop();
                      },
                      child: Text(
                        LocaleTexts.add_credit.tr(context),
                        style: const TextStyle(color: Colors.white),
                      ))
                ],
              ),
            ));
  }

  void showAddBeneficiaryDialog(BuildContext context, int? userid) {
    var myControllerName = TextEditingController();
    var myControllerNumber = TextEditingController();
    var myControllerNickname = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(LocaleTexts.add_beneficiary.tr(context)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: myControllerName,
              keyboardType: TextInputType.name,
              maxLength: 12,
              decoration: InputDecoration(
                label: Text(LocaleTexts.enter_name.tr(context)),
              ),
            ),
            TextField(
              controller: myControllerNumber,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp("[0-9]"))
              ],
              keyboardType: TextInputType.phone,
              maxLength: 9,
              decoration: InputDecoration(
                  label: Text(LocaleTexts.enter_number.tr(context)),
                  prefix: const Text("+971")),
            ),
            TextField(
              controller: myControllerNickname,
              keyboardType: TextInputType.name,
              maxLength: 20,
              decoration: InputDecoration(
                label: Text(LocaleTexts.enter_nick_name.tr(context)),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            ElevatedButton(
              onPressed: () {
                if (myControllerName.text.trim().length > 3 &&
                    myControllerNickname.text.trim().length > 3 &&
                    myControllerNumber.text.toString().trim().length == 9) {
                  context
                      .read<HomeCubit>()
                      .addBeneficiary(Beneficiary(
                          myControllerName.text.trim(),
                          "+971${myControllerNumber.text.toString().trim()}",
                          userid,
                          myControllerNickname.text))
                      .then((val) {
                    /* ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("You cant add more than 5 Beneficiary "),
                    ));*/
                  });
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Please add valid name and mobile number"),
                  ));
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                elevation: 3,
              ),
              child: const Text(
                "ADD",
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class BeneficiaryRowCard extends StatelessWidget {
  final Beneficiary beneficiary;

  const BeneficiaryRowCard({
    super.key,
    required this.beneficiary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 10, bottom: 10, right: 5),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
              color: Colors.black12,
              spreadRadius: 1,
              blurRadius: 4,
              offset: Offset(0, 3))
        ],

        color: Colors.white, //Border.all
        borderRadius: BorderRadius.circular(5),
      ),
      width: (MediaQuery.of(context).size.width) * 35 / 100,
      child: Column(
        children: [
          Text(
            "${beneficiary.name}",
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(
            "${beneficiary.number}",
            style: const TextStyle(color: Colors.black54, fontSize: 13),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: ColorSelect.primaryColor,
                disabledBackgroundColor:
                    ColorSelect.primaryColor.withOpacity(.5),
                padding: const EdgeInsets.symmetric(horizontal: 6)),
            onPressed: () {
              context.read<AppBloc>().saveBeneficiary(beneficiary);

              Navigator.of(context)
                  .pushNamed(
                TopUpScreen.routeName,
              )
                  .then((value) {
                if (value != null) {
                  context.read<HomeCubit>().removeMoneyToUser(
                      BlocProvider.of<AppBloc>(context).state.userInfoModel!,
                      double.parse(value.toString()));
                }
                int? userID =
                    BlocProvider.of<AppBloc>(context).state.userInfoModel?.id;
                context.read<HomeCubit>().getAllRecharges(userID!);
              });
            },
            child: const Text("Recharge Now",
                style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }
}
