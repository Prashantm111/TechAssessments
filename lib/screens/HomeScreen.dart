import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:techassesment/data/Recharge.dart';
import 'package:techassesment/data/UserInfoModel.dart';
import 'package:techassesment/screens/HomeScreenViewModel.dart';
import 'package:techassesment/screens/TopUpScreen.dart';

import '../Color.dart';
import '../data/Beneficiary.dart';
import '../utils/AppWidgets.dart';
import 'TopUpScreenViewModel.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/home-screen';

  const HomeScreen({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as UserInfoModel;

    return Home(
      userInfoModel: args,
    );
  }
}

class Home extends StatefulWidget {
  final UserInfoModel userInfoModel;

  const Home({super.key, required this.userInfoModel});

  @override
  State<Home> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<Home> {
  List<Beneficiary> beneficiaryList = [];
  List<Recharge> rechargeList = [];
  final HomeScreenViewmodel _model = HomeScreenViewmodel();
  final TopupScreenViewmodel _modelTopScreen = TopupScreenViewmodel();

  @override
  void initState() {
    refreshList();
    refreshList1();
    super.initState();
  }
  refreshList1() {
    _modelTopScreen.getAllRecharges(widget.userInfoModel.id).then((value) {
      setState(() {
        rechargeList = value;
        print("CCCCCCCCCCCCC  ${rechargeList.asMap()}");
      });
    });


  }
  refreshList() {
    _model.getAllBeneficiary(widget.userInfoModel.id).then((value) {
      setState(() {
        beneficiaryList = value;
      });
    });


  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.

    super.dispose();
  }

  //
  // insert(UserInfoModel model) {
  //   noteDatabase.insertUser(model).then((respond) async {
  //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //       content: Text("Note successfully added."),
  //       backgroundColor: Color.fromARGB(255, 4, 160, 74),
  //     ));
  //   }).catchError((error) {
  //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //       content: Text("Note failed to save."),
  //       backgroundColor: Color.fromARGB(255, 235, 108, 108),
  //     ));
  //   });
  // }

  // refreshNotes() {
  //   List<UserInfoModel> ly;
  //  noteDatabase.getAll().then((value) {
  //
  //    ly=
  //   });
  //
  //   print("CCCCCCCCCCCCCC ${list.s}");
  // }

  /*Return Initials */
  String getInitials(String name) => name.isNotEmpty
      ? name.trim().split(' ').map((l) => l[0]).take(2).join()
      : '';

  @override
  Widget build(BuildContext context) {
    String tittle = "Home Screen";
    var addMoneyController = TextEditingController();
    return Scaffold(
      appBar: AppToolBar(toolbarTittle: tittle),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 30,
              ),
              Center(
                child: Column(
                  children: [
                    Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(
                        child: Text(
                          getInitials("${widget.userInfoModel.name}"),
                          style: TextStyle(color: Colors.white, fontSize: 35),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      "${widget.userInfoModel.name}",
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "${widget.userInfoModel.number}",
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.all(16),
                width: MediaQuery.of(context).size.width,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
                        const Text(
                          "Credit Balance",
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          "${widget.userInfoModel.credit}",
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                                  title: const Text("Add Credit"),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      TextField(
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                                        ],
                                        controller: addMoneyController,
                                        keyboardType: TextInputType.number,
                                        maxLength: 5,
                                        decoration: const InputDecoration(
                                          label: Text("Enter Amount"),
                                        ),
                                      ),
                                      ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.redAccent,
                                            elevation: 3,
                                          ),
                                          onPressed: () {
                                            double newCredit = widget
                                                    .userInfoModel.credit! +
                                                double.parse(
                                                    addMoneyController.text);

                                            widget.userInfoModel.credit =
                                                newCredit;

                                            setState(() {
                                              _model.addMoneyToUser(
                                                  widget.userInfoModel);
                                            });

                                            Navigator.of(context).pop();
                                          },
                                          child: const Text(
                                            "Add Credit",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ))
                                    ],
                                  ),
                                ));
                      },
                      child: Text("Add Money"),
                    )
                  ],
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                reverse: true,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      width: 5,
                    ),
                    Row(
                      children: _createBeneficiaryRow(beneficiaryList),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    showAddbeneficiaryDialog(context, widget.userInfoModel.id);
                  },
                  child: Text("Add Beneficiary"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void showAddbeneficiaryDialog(BuildContext context, int? userid) {
    var myControllerName = TextEditingController();
    var myControllerNumber = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Add Beneficiary"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: myControllerName,
              keyboardType: TextInputType.name,
              maxLength: 20,
              decoration: const InputDecoration(
                label: Text("Enter Name"),
              ),
            ),
            TextField(
              controller: myControllerNumber,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp("[0-9]"))
              ],
              keyboardType: TextInputType.phone,
              maxLength: 9,
              decoration: const InputDecoration(
                  label: Text("Enter Number"), prefix: Text("+971")),
            ),
            const SizedBox(
              height: 15,
            ),
            ElevatedButton(
              onPressed: () {
                if (myControllerName.text.trim().length > 3 &&
                    myControllerNumber.text.toString().trim().length == 9) {
                  _model
                      .addBeneficiary(Beneficiary(
                          myControllerName.text.trim(),
                          "+971${myControllerNumber.text.toString().trim()}",
                          userid))
                      .then((val) {
                    if (val) {
                      refreshList();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("You cant add more than 5 Beneficiary "),
                      ));
                    }
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
              child: Text(
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

List<Widget> _createBeneficiaryRow(List<Beneficiary> beneficiaryList) {
  return List<Widget>.generate(beneficiaryList.length, (int index) {
    return BeneficiaryRowCard(
      beneficiary: beneficiaryList.elementAt(index),
    );
  });
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
            "${beneficiary.name}\n\n",
            maxLines: 2,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(
            "${beneficiary.number}",
            style: TextStyle(color: Colors.black54, fontSize: 13),
          ),
          ElevatedButton(

            style: ElevatedButton.styleFrom(
                backgroundColor: ColorSelect.primaryColor,
                disabledBackgroundColor: ColorSelect.primaryColor.withOpacity(.5) ,
                padding: const EdgeInsets.symmetric(horizontal: 6)),
            onPressed: () {
              Navigator.of(context).pushNamed(
                TopUpScreen.routeName,
                arguments: beneficiary,
              );
            },
            child: const Text("Recharge Now",
                style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }
}
