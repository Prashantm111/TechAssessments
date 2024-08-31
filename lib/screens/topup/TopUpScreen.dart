import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:techassesment/common/bloc/app_bloc.dart';
import 'package:techassesment/data/Beneficiary.dart';
import 'package:techassesment/data/Recharge.dart';
import 'package:techassesment/resource/Color.dart';

import '../../services/database_helper.dart';
import '../../utils/AppWidgets.dart';
import 'bloc/topup_cubit.dart';

class TopUpScreen extends StatelessWidget {
  static const routeName = '/top-screen';

  const TopUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Beneficiary? md = BlocProvider.of<AppBloc>(context).state.beneficiary;

    return BlocProvider<TopUpCubit>(
      create: (context) => TopUpCubit(
        databaseHelper: RepositoryProvider.of<DatabaseHelper>(context),
        topUpState: TopUpState(selectedBeneficiary: md),
      ),
      child: const TopUpUI(),
    );
  }
}

class TopUpUI extends StatelessWidget {
  const TopUpUI({super.key});

  @override
  Widget build(BuildContext context) {
    final myController = TextEditingController();

    return BlocConsumer<TopUpCubit, TopUpState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: const AppToolBar(toolbarTittle: "TopUp Screen"),
          body: Stack(children: [
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Recharge For",
                      style: TextStyle(color: Colors.black87, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.black12,
                              spreadRadius: 3,
                              blurRadius: 6,
                              offset: Offset(0, 5))
                        ],

                        color: ColorSelect.primaryColor, //Border.all
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${state.selectedBeneficiary?.name}",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            "${state.selectedBeneficiary?.number}",
                            style: const TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextField(
                      controller: myController,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9]"))
                      ],
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        label: const Text("Enter Amount"),
                        prefix: const Text("AED "),
                        suffixIcon: GestureDetector(
                          child: const Icon(Icons.cancel_outlined),
                          onTap: () {
                            myController.text = "";
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                          children: List<Widget>.generate(
                              context.read<TopUpCubit>().priceList.length,
                              (int index) {
                        return PriceCardItem(
                            price: context
                                .read<TopUpCubit>()
                                .priceList
                                .elementAt(index),
                            callback: () {
                              myController.text = context
                                  .read<TopUpCubit>()
                                  .priceList
                                  .elementAt(index)
                                  .toString();
                            });
                      })),
                    ),
                    const SizedBox(
                      height: 60,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (myController.text.toString().isNotEmpty &&
                              (double.parse(myController.text.toString()) >
                                  0)) {
                            var rechargeModel = Recharge(
                              username: state.selectedBeneficiary?.name,
                              benid: state.selectedBeneficiary?.id,
                              userid: state.selectedBeneficiary?.userid,
                              credit:
                                  double.parse(myController.text.toString()),
                            );
                            context
                                .read<TopUpCubit>()
                                .addRecharge(
                                    rechargeModel,
                                    BlocProvider.of<AppBloc>(context)
                                        .state
                                        .beneficiary!,
                                    BlocProvider.of<AppBloc>(context)
                                        .state
                                        .userInfoModel!)
                                .then((value) {
                              if (value == "Success") {
                                Navigator.of(context)
                                    .pop(myController.text.toString());
                              }
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(value),
                              ));
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: ColorSelect.primaryColor,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12)),
                        child: const Text("Recharge Now",
                            style:
                                TextStyle(color: Colors.white, fontSize: 12)),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Visibility(
              visible: state.isLoading,
              child: const Center(
                child: CenterProgressLoader(),
              ),
            ),
          ]),
        );
      },
    );
  }
}
