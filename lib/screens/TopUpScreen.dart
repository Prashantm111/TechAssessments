import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:techassesment/Color.dart';
import 'package:techassesment/data/Beneficiary.dart';
import 'package:techassesment/data/Recharge.dart';

import '../utils/AppWidgets.dart';
import 'TopUpScreenViewModel.dart';

class TopUpScreen extends StatelessWidget {
  static const routeName = '/top-screen';

  const TopUpScreen({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Beneficiary;
    return TopUp(
      beneficiary: args,
    );
  }
}

class TopUp extends StatefulWidget {
  final Beneficiary beneficiary;
  final TopupScreenViewmodel _modelTopScreen = TopupScreenViewmodel();

  TopUp({super.key, required this.beneficiary});

  @override
  State<TopUp> createState() => _TopScreenState();
}

class _TopScreenState extends State<TopUp> {
  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final VoidCallback onCancel;
    bool isEnaled = false;

    return Scaffold(
      appBar: AppToolBar(toolbarTittle: "TopUp Screen"),
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(20),
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
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${widget.beneficiary.name}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      "${widget.beneficiary.number}",
                      style: TextStyle(color: Colors.white, fontSize: 16),
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
                  label: Text("Enter Amount"),
                  prefix: Text("AED "),
                  suffixIcon: GestureDetector(
                    child: Icon(Icons.cancel_outlined),
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
                  children: _createPriceRow(myController),
                ),
              ),
              const SizedBox(
                height: 60,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    widget._modelTopScreen.addRecharge(Recharge(
                        benid: widget.beneficiary.id,
                        userid: widget.beneficiary.userid,
                        credit: double.parse(myController.text.toString())));
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: ColorSelect.primaryColor,
                      padding: const EdgeInsets.symmetric(horizontal: 12)),
                  child: const Text("Recharge Now",
                      style: TextStyle(color: Colors.white, fontSize: 12)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

List<int> priceList = [5, 10, 20, 30, 50, 75, 100];

List<Widget> _createPriceRow(TextEditingController myController) {
  return List<Widget>.generate(priceList.length, (int index) {
    return PriceCard(
        price: priceList.elementAt(index),
        callback: () {
          myController.text = priceList.elementAt(index).toString();
        });
  });
}

class PriceCard extends StatelessWidget {
  final int price;
  final VoidCallback callback;

  const PriceCard({
    super.key,
    required this.price,
    required this.callback,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: callback,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: Colors.black12, borderRadius: BorderRadius.circular(8)),
        child: Text(
          "AED $price",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
