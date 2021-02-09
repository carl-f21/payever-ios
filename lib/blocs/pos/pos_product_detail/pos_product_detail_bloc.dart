
import 'package:bloc/bloc.dart';

import 'package:payever/apis/api_service.dart';
import 'package:payever/checkout/models/models.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/products/models/models.dart';

import '../../bloc.dart';


class PosProductDetailScreenBloc extends Bloc<PosProductDetailScreenEvent, PosProductDetailScreenState> {
  final PosProductScreenBloc posProductScreenBloc;
  PosProductDetailScreenBloc(this.posProductScreenBloc);
  ApiService api = ApiService();

  @override
  PosProductDetailScreenState get initialState => PosProductDetailScreenState();

  @override
  Stream<PosProductDetailScreenState> mapEventToState(PosProductDetailScreenEvent event) async* {
    if (event is PosProductDetailScreenInitEvent) {
      yield state.copyWith(channelSetFlow: event.channelSetFlow);
    } else if (event is CartProductEvent) {
      yield* cartProduct(event.body);
    }
  }


  Stream<PosProductDetailScreenState> cartProduct(Map<String, dynamic> body) async* {
    yield state.copyWith(isUpdating: true);
    String token = GlobalUtils.activeToken.accessToken;
    String langCode = 'en';

    dynamic response = await api.patchCheckoutFlowOrder(
        token, state.channelSetFlow.id, langCode, body);

    if (response is Map) {
      ChannelSetFlow channelSetFlow = ChannelSetFlow.fromJson(response);
      yield state.copyWith(channelSetFlow: channelSetFlow);
      posProductScreenBloc.add(UpdateProductChannelSetFlowEvent(channelSetFlow));
      yield PosProductDetailScreenSuccess();
    }
    yield state.copyWith(isUpdating: false);
  }

}