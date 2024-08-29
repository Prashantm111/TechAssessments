import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:techassesment/data/Beneficiary.dart';
import 'package:techassesment/services/database_helper.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({required this.databaseHelper}) : super(HomeState()){
    fetchBenificiary();
  }
  final DatabaseHelper databaseHelper;

  fetchBenificiary() {

  }
}
