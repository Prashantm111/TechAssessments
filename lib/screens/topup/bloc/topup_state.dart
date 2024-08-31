part of 'topup_cubit.dart';

class TopUpState extends Equatable {
  final bool isLoading;
  final Beneficiary? selectedBeneficiary;

  const TopUpState({
    this.isLoading = false,
    this.selectedBeneficiary,
  });

  @override
  List<Object?> get props => [isLoading, selectedBeneficiary];

  TopUpState copyWith({bool? isLoading, Beneficiary? selectedBeneficiary}) {
    return TopUpState(
      isLoading: isLoading ?? this.isLoading,
      selectedBeneficiary: selectedBeneficiary ?? this.selectedBeneficiary,
    );
  }
}
