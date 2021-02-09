import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:payever/commons/utils/translations.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../theme.dart';
import 'checkout_top_button.dart';

class WorkshopTopBar extends StatefulWidget {
  final Function onTapSwitchCheckout;
  final Function onOpenTap;
  final Function onCloseTap;
  final Function onCopyPrefilledLink;
  final Function onPrefilledQrcode;
  final String title;
  final String businessName;
  final String openUrl;
  final bool isLoadingQrcode;

  WorkshopTopBar(
      {this.onOpenTap,
      this.onTapSwitchCheckout,
      this.onPrefilledQrcode,
      this.title,
      this.onCloseTap,
      this.businessName,
      this.openUrl,
      this.onCopyPrefilledLink,
      this.isLoadingQrcode = false});

  @override
  _WorkshopTopBarState createState() => _WorkshopTopBarState();
}

class _WorkshopTopBarState extends State<WorkshopTopBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      color: overlaySecondAppBar(),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 10,
          ),
          Text(
            widget.title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
          Spacer(),
          Visibility(
            visible: widget.onOpenTap != null,
            child: InkWell(
              onTap: () {
                widget.onOpenTap();
              },
              child: Container(
                height: 30,
                width: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: overlayBackground().withOpacity(1),
                ),
                child: Center(
                  child: Text(
                    Language.getCommerceOSStrings('actions.open'),
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: widget.onCloseTap != null,
            child: IconButton(
                icon: Icon(
                  Icons.close,
                  color: Colors.white,
                ),
                onPressed: () {
                  widget.onCloseTap();
                }),
          ),
          SizedBox(
            width: 10,
          ),
          widget.isLoadingQrcode
              ? Center(
                  child: Container(
                    width: 30,
                    height: 30,
                    padding: EdgeInsets.all(5),
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.white,
                      strokeWidth: 2,
                    ),
                  ),
                )
              : Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    color: overlayBackground().withOpacity(1),
                    shape: BoxShape.circle,
                  ),
                  child: PopupMenuButton<CheckOutPopupButton>(
                    child: Icon(
                      Icons.more_horiz,
                    ),
                    offset: Offset(0, 100),
                    onSelected: (CheckOutPopupButton item) => item.onTap(),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    color: overlayFilterViewBackground(),
                    itemBuilder: (BuildContext context) {
                      return _morePopup(context)
                          .map((CheckOutPopupButton item) {
                        return PopupMenuItem<CheckOutPopupButton>(
                          value: item,
                          child: Row(
                            children: <Widget>[
                              item.icon,
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                item.title,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
    );
  }

  List<CheckOutPopupButton> _morePopup(BuildContext context) {
    List<CheckOutPopupButton> checkoutPopups = [
      CheckOutPopupButton(
        title: 'Switch Checkout',
        icon: Container(),
        onTap: () {
          widget.onTapSwitchCheckout();
        },
      ),
      CheckOutPopupButton(
        title: 'Copy pay link',
        icon: SvgPicture.asset(
          'assets/images/pay_link.svg',
          width: 16,
          height: 16,
          color: iconColor(),
        ),
        onTap: () async {
          // Clipboard.setData(
          //     new ClipboardData(text: widget.checkoutScreenBloc.state.openUrl));
          Clipboard.setData(new ClipboardData(text: widget.openUrl));
          Fluttertoast.showToast(msg: 'Link successfully copied');
        },
      ),
      CheckOutPopupButton(
        title: 'Copy prefilled link',
        icon: SvgPicture.asset(
          'assets/images/prefilled_link.svg',
          width: 16,
          height: 16,
          color: iconColor(),
        ),
        onTap: () async {
          widget.onCopyPrefilledLink();
        },
      ),
      CheckOutPopupButton(
        title: 'E-mail prefilled link',
        icon: SvgPicture.asset(
          'assets/images/email_link.svg',
          width: 16,
          height: 16,
          color: iconColor(),
        ),
        onTap: () async {
          _sendMail(
              '',
              'Pay by payever Link',
              'Dear customer, \\n'
                  '${widget.businessName} would like to invite you to pay online via payever. Please click the link below in order to pay for your purchase at ${widget.businessName}.\\n'
                  '${widget.openUrl}\\n'
                  ' For any questions to ${widget.businessName} regarding the purchase itself, please reply to this email, for technical questions or questions regarding your payment, please email support@payever.de.');
        },
      ),
      CheckOutPopupButton(
        title: 'Prefilled QR code',
        icon: SvgPicture.asset(
          'assets/images/prefilled_qr.svg',
          width: 16,
          height: 16,
          color: iconColor(),
        ),
        onTap: () async {
          widget.onPrefilledQrcode();
        },
      ),
    ];
    return checkoutPopups;
  }

  _sendMail(String toMailId, String subject, String body) async {
    var url = Uri.encodeFull('mailto:$toMailId?subject=$subject&body=$body');
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
