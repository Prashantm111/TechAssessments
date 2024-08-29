part of 'app_bloc.dart';


class AppState extends Equatable {
  const AppState({this.userInfoModel, this.isLoading = false});
  final UserInfoModel? userInfoModel;
  final bool isLoading;

  @override
  List<Object?> get props => [userInfoModel,isLoading];

  AppState copyWith({
    UserInfoModel? userInfoModel,
    bool? isLoading,
  }) {
    return AppState(
      userInfoModel: userInfoModel ?? this.userInfoModel,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
