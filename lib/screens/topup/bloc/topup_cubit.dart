import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:techassesment/data/Beneficiary.dart';
import 'package:techassesment/data/UserInfo.dart';
import 'package:techassesment/services/database_helper.dart';

import '../../../data/Recharge.dart';

part 'topup_state.dart';

class TopUpCubit extends Cubit<TopUpState> {
  TopUpCubit({required this.databaseHelper, required TopUpState topUpState})
      : super(topUpState) {
    getAllRecharges(topUpState.selectedBeneficiary?.id);
  }

  final DatabaseHelper databaseHelper;
  List<Recharge> _listRecharges = [];
  List<int> priceList = [5, 10, 20, 30, 50, 75, 100];

  /*Get All the Recharges done by user*/
  Future<List<Recharge>> getAllRecharges(int? userID) async {
    await databaseHelper.getAllRecharge(userID).then((value) {
      _listRecharges = value;
    });
    return _listRecharges;
  }

/* To add new recharge in table */
  Future<String> addRecharge(Recharge data, Beneficiary beneficiary,
      UserInfoModel userInfoModel) async {
    if (data.credit! > double.parse(userInfoModel.credit.toString())) {
      return "Insufficient balance, Please add some Credit";
    }
    emit(state.copyWith(isLoading: true));
    double? totalRecharge =
        await databaseHelper.getTotalRechargeByUser(beneficiary.id!);
    await Future.delayed(const Duration(seconds: 2));
    if ((totalRecharge != null && totalRecharge! > 500) ||
        (data.credit! > 500)) {
      emit(state.copyWith(isLoading: false));
      return "Not Allowed to Recharge more that 500 for a Beneficiary in month";
    }
    var res = await databaseHelper.insertRecharge(data).then((val) {});
    emit(state.copyWith(isLoading: false));
    return "Success";
  }
}
