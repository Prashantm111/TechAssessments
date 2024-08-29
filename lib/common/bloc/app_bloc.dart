import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:techassesment/data/UserInfoModel.dart';
import 'package:techassesment/services/database_helper.dart';


part 'app_state.dart';

class AppBloc extends Cubit<AppState> {
  AppBloc(this.databaseHelper) : super(AppState()){
    refreshNotes();
  }

  final DatabaseHelper databaseHelper;

  refreshNotes() {
    databaseHelper.getAllUsers().then((totalUsers) {
      if (totalUsers.isEmpty) {
        databaseHelper.insertUser(
            UserInfoModel("Advert David", "+971555555551", "0", 3000.0));
        databaseHelper.insertUser(
            UserInfoModel("Robert Johnson", "+971555555552", "1", 3500.0));
      }
    });
  }

  loginUser(bool isValidUser)async{
    emit(state.copyWith(isLoading: true));
    await Future.delayed(const Duration(seconds: 2));
    UserInfoModel? loggedInUser = await databaseHelper.getUserByStatus(isValidUser ? "1"  : "0");
    emit(state.copyWith(userInfoModel: loggedInUser, isLoading: false));
  }
}
