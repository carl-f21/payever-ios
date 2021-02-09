
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payever/apis/api_service.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/utils/common_utils.dart';

class CheckoutChannelSetScreenBloc extends Bloc<CheckoutChannelSetScreenEvent, CheckoutChannelSetScreenState> {
  final CheckoutScreenBloc checkoutScreenBloc;

  CheckoutChannelSetScreenBloc({this.checkoutScreenBloc});

  ApiService api = ApiService();
  String token = GlobalUtils.activeToken.accessToken;

  @override
  CheckoutChannelSetScreenState get initialState => CheckoutChannelSetScreenState();

  @override
  Stream<CheckoutChannelSetScreenState> mapEventToState(
      CheckoutChannelSetScreenEvent event) async* {
    if (event is CheckoutChannelSetScreenInitEvent) {
      List<ChannelSet> channelSets = checkoutScreenBloc.state.channelSets.where((element) => element.type == event.type).toList();
      yield state.copyWith(
        business: event.business,
        channelSets: channelSets,
        type: event.type,
      );
    } else if (event is UpdateChannelSet) {
      yield* updateChannelSet(event.channelSet, event.checkoutId);
    } else if (event is GetChannelSetEvent) {
      yield* getChannelSets();
    }
  }

  Stream<CheckoutChannelSetScreenState> updateChannelSet(ChannelSet channelSet, String checkoutId) async* {
    List<ChannelSet> chsets = [];
    String chId;
    chsets.addAll(state.channelSets);
    int index = chsets.indexOf(channelSet);
    ChannelSet chset = chsets[index];
    if (chset.checkout == checkoutId) {
      chset.checkout = '';
    } else {
      chset.checkout = checkoutId;
      chId = checkoutId;
    }
    chsets[index] = chset;
    await api.patchCheckoutChannelSet(token, state.business, chset.id, chId);
    yield state.copyWith(channelSets: chsets);
    checkoutScreenBloc.add(GetChannelSet());
  }

  Stream<CheckoutChannelSetScreenState> getChannelSets() async* {
    List<ChannelSet> channelSets = [];
    dynamic channelSetResponse = await api.getChannelSet(state.business, token);
    if (channelSetResponse is List) {
      channelSetResponse.forEach((element) {
        channelSets.add(ChannelSet.fromJson(element));
      });
    }
    List<ChannelSet> typeChannelSets = channelSets.where((element) => element.type == state.type).toList();

    yield state.copyWith(channelSets: typeChannelSets);
  }
}