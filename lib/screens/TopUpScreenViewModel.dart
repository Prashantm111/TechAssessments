import 'package:flutter/material.dart';
import 'package:techassesment/data/Beneficiary.dart';

import '../data/Recharge.dart';
import '../services/database_helper.dart';

class TopupScreenViewmodel extends ChangeNotifier {
  DatabaseHelper noteDatabase = DatabaseHelper.instance;
  List<Recharge> _listRecharges = [];

  Future<List<Recharge>> getAllRecharges(int? userID) async {
    await noteDatabase.getAllRecharge(userID).then((value) {
      _listRecharges = [];
      _listRecharges = value;
      notifyListeners();
    });
    return _listRecharges;
  }

  Future<void> addRecharge(Recharge data) async {
   await noteDatabase.insertRecharge(data);
  }
}
