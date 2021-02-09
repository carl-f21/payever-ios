import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/blocs/pos/pos_state.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/commons/views/custom_elements/wallpaper.dart';
import 'package:payever/settings/widgets/app_bar.dart';

import '../../theme.dart';

class PosSettingScreen extends StatefulWidget {
  final PosScreenBloc screenBloc;

  const PosSettingScreen({this.screenBloc});

  @override
  _PosSettingScreenState createState() => _PosSettingScreenState();
}

class _PosSettingScreenState extends State<PosSettingScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: widget.screenBloc,
      listener: (BuildContext context, PosScreenState state) async {

      },
      child: BlocBuilder<PosScreenBloc, PosScreenState>(
        bloc: widget.screenBloc,
        builder: (BuildContext context, PosScreenState state) {
          return Scaffold(
            resizeToAvoidBottomPadding: true,
            appBar: Appbar('Setting'),
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

  Widget _getBody(PosScreenState state) {
    return Container(
      padding: EdgeInsets.all(16),
      width: Measurements.width,
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                'Business UUID',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 8),
              ),
              Expanded(
                child: AutoSizeText(
                  widget.screenBloc.state.activeBusiness.id,
                  minFontSize: 12,
                  maxLines: 2,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 8),
              ),
              MaterialButton(
                height: 32,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                color: overlayBackground(),
                child: Text(
                  state.businessCopied ? 'Copied': 'Copy',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500
                  ),
                ),
                onPressed: () {
                  widget.screenBloc.add(CopyBusinessEvent(businessId: widget.screenBloc.state.activeBusiness.id));
                },
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Text(
                'Terminal UUID',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 8),
              ),
              Expanded(
                child: AutoSizeText(
                  state.activeTerminal.id,
                  minFontSize: 12,
                  maxLines: 2,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 8),
              ),
              MaterialButton(
                height: 32,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                color: overlayBackground(),
                child: Text(
                  state.terminalCopied ? 'Copied': 'Copy',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500
                  ),
                ),
                onPressed: () {
                  widget.screenBloc.add(CopyTerminalEvent(
                      businessId: widget.screenBloc.state.activeBusiness.id,
                      terminal: state.activeTerminal));
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
