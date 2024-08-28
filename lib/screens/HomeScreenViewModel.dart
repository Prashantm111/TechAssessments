import 'package:flutter/cupertino.dart';
import 'package:techassesment/data/Recharge.dart';
import 'package:techassesment/data/UserInfoModel.dart';

import '../data/Beneficiary.dart';
import '../services/database_helper.dart';

class HomeScreenViewmodel extends ChangeNotifier {
  DatabaseHelper noteDatabase = DatabaseHelper.instance;
  List<Beneficiary> _listBeneficiary = [];

  List<Beneficiary> get persons => _listBeneficiary;

  Future<List<Beneficiary>> getAllBeneficiary(int? userID) async {
    await noteDatabase.getAllBeneficiary(userID).then((value) {
      _listBeneficiary = [];
      _listBeneficiary = value;
      notifyListeners();
    });
    return _listBeneficiary;
  }

  Future<bool> addBeneficiary(Beneficiary data) async {
    if (persons.length < 15) {
      await noteDatabase.insertBeneficiary(data);
      return true;
    } else {
      return false;
    }
  }

  Future<int> addMoneyToUser(UserInfoModel data) async {
    return await noteDatabase.addMoneyToUser(data);
  }
}
