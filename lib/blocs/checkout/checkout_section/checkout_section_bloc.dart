import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payever/apis/api_service.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/utils/common_utils.dart';
import '../checkout_bloc.dart';
import 'checkout_section.dart';

class CheckoutSectionScreenBloc extends Bloc<CheckoutSectionScreenEvent, CheckoutSectionScreenState> {

  ApiService api = ApiService();
  String token = GlobalUtils.activeToken.accessToken;
  final CheckoutScreenBloc checkoutScreenBloc;

  CheckoutSectionScreenBloc({this.checkoutScreenBloc});

  @override
  CheckoutSectionScreenState get initialState => CheckoutSectionScreenState();

  @override
  Stream<CheckoutSectionScreenState> mapEventToState(
      CheckoutSectionScreenEvent event) async* {
    if (event is UpdateCheckoutSectionsEvent) {
      yield* updateCheckoutSettings();
    }
  }

  Stream<CheckoutSectionScreenState> updateCheckoutSettings() async* {
    yield state.copyWith(isUpdating: true);
//    Checkout checkout = event.checkout;
//    Map<String, dynamic>body = event.checkout.settings.toDictionary();
//    dynamic response = await api.patchCheckout(GlobalUtils.activeToken.accessToken, event.businessId, checkout.id, body);
//    if (!(response is DioError)) {
//      yield CheckoutSectionScreenSuccess();
//    } else {
//      yield CheckoutSectionScreenFailure(error: response);
//    }
    yield state.copyWith(isUpdating: false);
  }
}