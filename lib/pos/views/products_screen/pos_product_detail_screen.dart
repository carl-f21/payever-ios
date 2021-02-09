import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:payever/checkout/models/models.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/commons/utils/env.dart';
import 'package:payever/commons/views/custom_elements/wallpaper.dart';
import 'package:payever/products/models/models.dart';
import 'package:payever/settings/widgets/app_bar.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/theme.dart';

class PosProductDetailScreen extends StatefulWidget {
  final ProductsModel productsModel;
  final PosProductScreenBloc posProductScreenBloc;
  final ChannelSetFlow channelSetFlow;

  PosProductDetailScreen(
      this.productsModel, this.posProductScreenBloc, this.channelSetFlow);

  @override
  _PosProductDetailScreenState createState() =>
      _PosProductDetailScreenState(productsModel);
}

class _PosProductDetailScreenState extends State<PosProductDetailScreen> {
  final ProductsModel product;
  bool _isPortrait;
  bool _isTablet;
  PosProductDetailScreenBloc screenBloc;
  _PosProductDetailScreenState(this.product);

  double imageHeight = 0;

  @override
  void initState() {
    screenBloc = PosProductDetailScreenBloc(widget.posProductScreenBloc)
      ..add(PosProductDetailScreenInitEvent(widget.channelSetFlow));
    super.initState();
  }

  @override
  void dispose() {
    screenBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _isPortrait = Orientation.portrait == MediaQuery.of(context).orientation;
    Measurements.height = (_isPortrait
        ? MediaQuery.of(context).size.height
        : MediaQuery.of(context).size.width);
    Measurements.width = (_isPortrait
        ? MediaQuery.of(context).size.width
        : MediaQuery.of(context).size.height);
    _isTablet = Measurements.width < 600 ? false : true;

    if (imageHeight == 0) {
      imageHeight = _isPortrait ? Measurements.width : Measurements.height;
    }

    return BlocListener(
      bloc: screenBloc,
      listener: (BuildContext context, PosProductDetailScreenState state) async {
        if (state is PosProductDetailScreenSuccess) {
          Navigator.pop(context);
        }
      },
      child: BlocBuilder<PosProductDetailScreenBloc, PosProductDetailScreenState>(
        bloc: screenBloc,
        builder: (BuildContext context, PosProductDetailScreenState state) {
          return Scaffold(
            resizeToAvoidBottomPadding: true,
            appBar: Appbar(product.title ?? ''),
            body: SafeArea(
              bottom: false,
              child: BackgroundBase(
                true,
                body: _getBody(state),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _getBody(PosProductDetailScreenState state) {
    return Center(
      child: state.isLoading
          ? CircularProgressIndicator()
          : SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    height: imageHeight,
                    alignment: Alignment.center,
                    child: CachedNetworkImage(
                      imageUrl:
                          '${Env.storage}/products/${product.images.isEmpty ? null : product.images.first}',
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      color: Colors.white,
                      placeholder: (context, url) => Container(
                        child: Center(
                          child: Container(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            'assets/images/no_image.svg',
                            color: Colors.black54,
                            width: 150,
                            height: 150,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    '${formatter.format(product.price)} ${Measurements.currency(product.currency)}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        product.description,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      if (state.isUpdating) return;
                      List<dynamic> cards = [];
                      bool alreadyAdded = false;
                      if (state.channelSetFlow.cart != null && state.channelSetFlow.cart.isNotEmpty) {
                        state.channelSetFlow.cart.forEach((element) {
                          num quantity = element.quantity;
                          if (element.id == product.id) {
                            quantity ++;
                            alreadyAdded = true;
                          }
                          Map<String, dynamic> card = {
                            'id': element.id,
                            'name': element.name,
                            'quantity': quantity,
                            'uuid': element.uuid,
                          };
                          cards.add(card);
                        });
                      }
                      if (!alreadyAdded) {
                        cards.add({
                          'id': product.id,
                          'name': product.title,
                          'quantity': 1,
                          'uuid': product.id,
                        });
                      }
                      Map<String, dynamic> body = {'cart': cards};
                      screenBloc.add(CartProductEvent(body: body));
                    },
                    child: Container(
                      width: double.infinity,
                      height: 40,
                      alignment: Alignment.center,
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: overlayBackground(),
                      ),
                      child: state.isUpdating
                          ? Center(
                              child: Container(
                                width: 30,
                                height: 30,
                                child: CircularProgressIndicator(
                                strokeWidth: 2,
                            ),
                              ))
                          : Text(
                              'In the Cart',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  )
                ],
              ),
            ),
    );
  }
}
