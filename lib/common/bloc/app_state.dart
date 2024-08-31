part of 'app_bloc.dart';

class AppState extends Equatable {
  const AppState(
      {this.userInfoModel, this.isLoading = false, this.beneficiary});

  final UserInfoModel? userInfoModel;
  final Beneficiary? beneficiary;
  final bool isLoading;
 
  @override
  List<Object?> get props => [userInfoModel, isLoading, beneficiary];

  AppState copyWith({
    UserInfoModel? userInfoModel,
    bool? isLoading,
    Beneficiary? beneficiary,
  }) {
    return AppState(
      userInfoModel: userInfoModel ?? this.userInfoModel,
      isLoading: isLoading ?? this.isLoading,
      beneficiary: beneficiary ?? this.beneficiary,
    );
  }
}
