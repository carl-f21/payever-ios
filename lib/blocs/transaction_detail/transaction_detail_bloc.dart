import 'package:bloc/bloc.dart';
import 'package:payever/apis/api_service.dart';
import 'package:payever/blocs/transaction_detail/transaction_detail.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/transactions/transactions.dart';

import '../bloc.dart';

class TransactionDetailScreenBloc extends Bloc<TransactionDetailScreenEvent, TransactionDetailScreenState> {
  TransactionDetailScreenBloc();
  ApiService api = ApiService();

  @override
  TransactionDetailScreenState get initialState => TransactionDetailScreenState();

  @override
  Stream<TransactionDetailScreenState> mapEventToState(TransactionDetailScreenEvent event) async* {
    if (event is TransactionDetailScreenInitEvent) {
      yield* getTransactionDetail(event.businessId, event.transactionId);
    }
  }

  Stream<TransactionDetailScreenState> getTransactionDetail(String businessId, String transactionId) async* {
    yield state.copyWith(isLoading: true);
    try {
      dynamic obj = await api.getTransactionDetail(businessId, GlobalUtils.activeToken.accessToken, transactionId);
      TransactionDetails data = TransactionDetails.fromJson(obj);
      yield state.copyWith(isLoading: false, data: data);
    } catch (error) {
      if (error.toString().contains('401')) {
        GlobalUtils.clearCredentials();
        yield TransactionDetailScreenFailure(error: error.toString());
      }
      yield state.copyWith(isLoading: false,);
      print(error.toString());
    }
  }

}