part of 'home_cubit.dart';

// class HomeState extends Equatable {
//   List<Beneficiary> beneficiaryList = [];
//   @override
//   List<Object?> get props => [];
// }

class HomeState extends Equatable {
  HomeState({
    this.beneficiaryList,
    this.selectedBeneficiary,
    this.isLoading = false,
    this.rechargesList,
    this.isRechargeViewSelected = true,
  });

  final List<Beneficiary>? beneficiaryList;
  final Beneficiary? selectedBeneficiary;
  final bool isLoading;
  final List<Recharge>? rechargesList;
  final bool isRechargeViewSelected;

  @override
  List<Object?> get props => [
        beneficiaryList,
        selectedBeneficiary,
        isLoading,
        rechargesList,
        isRechargeViewSelected
      ];

  HomeState copyWith(
      {List<Beneficiary>? beneficiaryList,
      Beneficiary? selectedBeneficiary,
      bool? isLoading,
      bool? isRechargeViewSelected,
      List<Recharge>? rechargesList}) {
    return HomeState(
      selectedBeneficiary: selectedBeneficiary ?? this.selectedBeneficiary,
      isLoading: isLoading ?? this.isLoading,
      isRechargeViewSelected:
          isRechargeViewSelected ?? this.isRechargeViewSelected,
      beneficiaryList: beneficiaryList ?? this.beneficiaryList,
      rechargesList: rechargesList ?? this.rechargesList,
    );
  }
}
