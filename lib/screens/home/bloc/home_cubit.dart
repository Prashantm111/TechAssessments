import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:techassesment/data/Beneficiary.dart';
import 'package:techassesment/services/database_helper.dart';

import '../../../data/Recharge.dart';
import '../../../data/UserInfo.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final int userId;
  final DatabaseHelper databaseHelper;

  HomeCubit({required this.databaseHelper, required this.userId})
      : super(HomeState()) {
    fetchBeneficiary(userId);
    getAllRecharges(userId);
  }

/* TO get All the Beneficiary of a user from Database */
  fetchBeneficiary(int userID) async {
    List<Beneficiary> beneficiaryList = [];
    await databaseHelper.getAllBeneficiary(userID).then((value) {
      beneficiaryList = value;
      emit(state.copyWith(beneficiaryList: beneficiaryList));
    });
  }

/* TO get all the recharges  of a user from Database  to show for History tab*/
  getAllRecharges(int userID) async {
    List<Recharge> _listRecharges = [];
    await databaseHelper.getAllRecharge(userID).then((value) {
      _listRecharges = [];
      _listRecharges = value;
      emit(state.copyWith(rechargesList: _listRecharges));
    });
  }

/* To add More Credit to User */
  Future<int> addMoneyToUser(
      UserInfoModel userInfoModel, double addedMoney) async {
    double newCredit = userInfoModel.credit! + addedMoney;
    userInfoModel.credit = newCredit;
    return await databaseHelper.addMoneyToUser(userInfoModel);
  }

/* To add Remove Credit to User */
  Future<int> removeMoneyToUser(
      UserInfoModel userInfoModel, double addedMoney) async {
    double newCredit = userInfoModel.credit! - addedMoney;
    userInfoModel.credit = newCredit;
    return await databaseHelper.addMoneyToUser(userInfoModel);
  }
/* Add the Beneficiary to the DB */
  Future<void> addBeneficiary(Beneficiary data) async {
    if (state.beneficiaryList!.length < 55) {
      var newBeneficiary = await databaseHelper.insertBeneficiary(data);
      List<Beneficiary> oldlist = [];
      oldlist.addAll(state.beneficiaryList ?? []);
      oldlist.add(newBeneficiary);
      emit(state.copyWith(beneficiaryList: oldlist));
    }
  }


  String getInitials(String name) => name.isNotEmpty
      ? name.trim().split(' ').map((l) => l[0]).take(2).join()
      : '';
/* to change view of recharge and tab */
  onToggleTab(int position) {
    if (position == 0) {
      emit(state.copyWith(isRechargeViewSelected: true));
    }
    if (position == 1) {
      emit(state.copyWith(isRechargeViewSelected: false));
    }
  }
}
