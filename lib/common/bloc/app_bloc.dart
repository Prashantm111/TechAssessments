import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:techassesment/data/UserInfo.dart';
import 'package:techassesment/services/database_helper.dart';

import '../../data/Beneficiary.dart';

part 'app_state.dart';

class AppBloc extends Cubit<AppState> {
  AppBloc(this.databaseHelper) : super(const AppState()) {
    insertUserInDB();
  }

  final DatabaseHelper databaseHelper;

/* Adding Verified and Non Verified User in Table for Further use in application */
  insertUserInDB() {
    databaseHelper.getAllUsers().then((totalUsers) {
      if (totalUsers.isEmpty) {
        databaseHelper.insertUser(
            UserInfoModel("Advert David", "+971555555551", "0", 3000.0));
        databaseHelper.insertUser(
            UserInfoModel("Robert Johnson", "+971555555552", "1", 3500.0));
      }
    });
  }

/*Function to get and update user info from table inside the app block for global use */
  Future<void> loginUser(bool isValidUser) async {
    emit(state.copyWith(isLoading: true));
    UserInfoModel? loggedInUser =
        await databaseHelper.getUserByStatus(isValidUser ? "1" : "0");
    await Future.delayed(const Duration(seconds: 2));
    emit(state.copyWith(userInfoModel: loggedInUser, isLoading: false));
  }

/*Function to save selected Beneficiary from a user for TopUp Screen in AppBloc */
  saveBeneficiary(Beneficiary beneficiary) {
    emit(state.copyWith(beneficiary: beneficiary));
  }
}
