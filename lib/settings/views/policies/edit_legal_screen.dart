
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html_editor/html_editor.dart';
import 'package:flutter_svg/svg.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/blocs/setting/setting_bloc.dart';
import 'package:payever/commons/models/business.dart';
import 'package:payever/commons/utils/translations.dart';
import 'package:payever/commons/view_models/global_state_model.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';
import 'package:payever/commons/views/custom_elements/wallpaper.dart';
import 'package:payever/settings/models/models.dart';
import 'package:payever/theme.dart';

class LegalEditorScreen extends StatefulWidget {
  final GlobalStateModel globalStateModel;
  final SettingScreenBloc setScreenBloc;
  final String type;

  LegalEditorScreen({this.setScreenBloc, this.globalStateModel, this.type});

  @override
  _LegalEditorScreenState createState() => _LegalEditorScreenState();
}

class _LegalEditorScreenState extends State<LegalEditorScreen> {

  GlobalKey<HtmlEditorState> keyEditor = GlobalKey();
  Business activeBusiness;

  @override
  void initState() {
    widget.setScreenBloc.add(GetLegalDocumentEvent(type: widget.type));
    activeBusiness =
        widget.globalStateModel.currentBusiness;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _body;
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    super.dispose();
  }

  get _body {
    return BlocListener(
      bloc: widget.setScreenBloc,
      listener: (BuildContext context, state) {
        if (state is SettingScreenUpdateSuccess) {
          Navigator.pop(context);
        } else if (state is SettingScreenStateFailure) {}
      },
      child: BlocBuilder<SettingScreenBloc, SettingScreenState>(
        bloc: widget.setScreenBloc,
        builder: (context, state) {
          bool isLoading = true;
          if (state.isLoading) {
            isLoading = true;
          }
          if (state.legalDocument == null) {
            isLoading = true;
          } else {
            if (state.legalDocument.type == widget.type) {
              isLoading = false;
            }
          }

          return Scaffold(
            resizeToAvoidBottomPadding: false,
            appBar: _appBar(state),
            body: SafeArea(
              bottom: false,
              child: BackgroundBase(
                true,
                body: isLoading ? Center(
                  child: CircularProgressIndicator(),
                ): HtmlEditor(
                  value: state.legalDocument != null ? state.legalDocument.content ?? '': '',
                  key: keyEditor,
                  useBottomSheet: true,
                  height: double.infinity,
                  showBottomToolbar: false,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _appBar(SettingScreenState state) {
    return AppBar(
      centerTitle: false,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Row(
        children: <Widget>[
          Text(
            policiesScreenTitles[widget.type],
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      actions: <Widget>[
        MaterialButton(
          onPressed: () async {
            _saveDocument(state);
          },
          child: state.isUpdating || state.isLoading
              ? Center(
            child: Container(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            ),
          ) : Text(
            'Save',
            style: TextStyle(color: Colors.white),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(6),
          child: InkWell(
            child: SvgPicture.asset(
              'assets/images/closeicon.svg',
              width: 16,
              color: Colors.white,
            ),
            onTap: () {
              showConfirmDialog();
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: 8),
        ),
      ],
    );
  }

  _saveDocument(SettingScreenState state) async{
    final txt = await keyEditor.currentState.getText();
    print(txt);
    Map<String, dynamic> body = {
      'business': {
        'id': state.business,
      },
      'content': txt,
      'type': widget.type,
    };
    widget.setScreenBloc.add(UpdateLegalDocumentEvent(content: body, type: widget.type));

  }

  showConfirmDialog() {
    showCupertinoDialog(
      context: context,
      builder: (builder) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Center(
            child: Wrap(
                children: <Widget>[
                  BlurEffectView(
                    color: overlayBackground(),
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 16),
                        ),
                        SvgPicture.asset(
                          'assets/images/info.svg',
                          color: iconColor(),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 16),
                        ),
                        Text(
                          Language.getPosStrings('Do you really want to close editing the policy?'),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 16),
                        ),
                        Text(
                          Language.getPosStrings('Because all data will be lost when unsaved and you will not be able to restore it'),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 16),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            MaterialButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              height: 24,
                              elevation: 0,
                              minWidth: 0,
                              color: overlayBackground(),
                              child: Text(
                                Language.getSettingsStrings('actions.no'),
                              ),
                            ),
                            MaterialButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              height: 24,
                              elevation: 0,
                              minWidth: 0,
                              color: overlayBackground(),
                              child: Text(
                                Language.getSettingsStrings('actions.yes'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ]
            ),
          ),
        );
      },
    );
  }

}
