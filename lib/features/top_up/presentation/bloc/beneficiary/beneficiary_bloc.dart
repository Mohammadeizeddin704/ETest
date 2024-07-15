import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:etest/features/top_up/domain/entities/beneficiary_entity.dart';
import 'package:etest/features/top_up/domain/usecases/beneficiary/add_beneficy.dart';
import 'package:etest/features/top_up/domain/usecases/beneficiary/delete_beneficy.dart';
import 'package:etest/features/top_up/domain/usecases/beneficiary/get_beneficiars.dart';
import '../../../../../core/strings/messages.dart';
import 'package:equatable/equatable.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/strings/failures.dart';

part 'beneficiary_event.dart';

part 'beneficiary_state.dart';

class BeneficiaryBloc extends Bloc<BeneficiaryEvent, BeneficiaryState> {
  final AddBeneficiaryUsecase addBeneficiary;
  final DeleteBeneficiaryUsecase deleteBeneficiary;
  final GetBeneficiariesUsecase getBeneficiaries;
  late List<BeneficiaryEntity> beneficiaries;

  BeneficiaryBloc(
      {required this.addBeneficiary,
      required this.deleteBeneficiary,
      required this.getBeneficiaries})
      : super(LoadingBeneficiaryState()) {
    beneficiaries = [];
    on<AddBeneficiaryEvent>(_onAddBeneficiaryEvent);
    on<DeleteBeneficiaryEvent>(_onDeleteBeneficiaryEvent);
    on<GetBeneficiariesEvent>(_onGetBeneficiariesEvent);
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case OfflineFailure:
        return OFFLINE_FAILURE_MESSAGE;
      default:
        return "Unexpected Error , Please try again later .";
    }
  }

  FutureOr<void> _onAddBeneficiaryEvent(
      AddBeneficiaryEvent event, Emitter<BeneficiaryState> emit) async {
    if (beneficiaries.length >= 5) {
      emit(const MaxBeneficiariesLimitState(
          message: MAX_BENEFICIARY_MESSAGE));
      return;
    }
    emit(LoadingBeneficiaryState());
    final failureOrDoneMessage = await addBeneficiary(event.beneficiary);
    return failureOrDoneMessage.fold(
      (failure) => emit(ErrorBeneficiaryState(
        message: _mapFailureToMessage(failure),
      )),
      (_) {
        emit(const MessageBeneficiaryState(message: BENEFICIARY_ADD_SUCCESS_MESSAGE));
        add(const GetBeneficiariesEvent());
      },
    );
  }

  FutureOr<void> _onDeleteBeneficiaryEvent(
      DeleteBeneficiaryEvent event, Emitter<BeneficiaryState> emit) async {
    emit(LoadingBeneficiaryState());
    final failureOrDoneMessage = await deleteBeneficiary(event.beneficiaryId);
    return failureOrDoneMessage.fold(
      (failure) => emit(ErrorBeneficiaryState(
        message: _mapFailureToMessage(failure),
      )),
      (_) {
        emit(const MessageBeneficiaryState(message: BENEFICIARY_DELETE_SUCCESS_MESSAGE));
        add(const GetBeneficiariesEvent());
      },
    );
  }

  FutureOr<void> _onGetBeneficiariesEvent(
      GetBeneficiariesEvent event, Emitter<BeneficiaryState> emit) async {
    final failureOrDoneMessage = await getBeneficiaries();
    return failureOrDoneMessage.fold(
      (failure) => emit(ErrorBeneficiaryState(
        message: _mapFailureToMessage(failure),
      )),
      (data) {
        beneficiaries = data;
        emit(LoadedBeneficiariesState(data));
      },
    );
  }
}
