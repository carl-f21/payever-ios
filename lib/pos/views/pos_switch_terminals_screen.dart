import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';
import 'package:payever/commons/views/custom_elements/wallpaper.dart';
import 'package:payever/login/login_screen.dart';
import 'package:payever/theme.dart';

import 'pos_create_terminal_screen.dart';

class PosSwitchTerminalsScreen extends StatefulWidget {
  final PosScreenBloc screenBloc;

  PosSwitchTerminalsScreen({
    this.screenBloc,
  });

  @override
  createState() => _PosSwitchTerminalsScreenState();
}

class _PosSwitchTerminalsScreenState extends State<PosSwitchTerminalsScreen> {
  bool _isPortrait;
  bool _isTablet;
  String imageBase = Env.storage + '/images/';

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String wallpaper;
  bool isLoading = false;
  Terminal selectedTerminal;
  Terminal defaultTerminal;

  @override
  void initState() {
    selectedTerminal = widget.screenBloc.state.activeTerminal;
    List<Terminal> terminals = widget.screenBloc.state.terminals;
    defaultTerminal = terminals.where((element) => element.active).first;

    widget.screenBloc.add(GetPosTerminalsEvent());
    super.initState();
  }

  @override
  void dispose() {
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

    return BlocListener(
      bloc: widget.screenBloc,
      listener: (BuildContext context, PosScreenState state) async {
        if (state is PosScreenFailure) {
          Navigator.pushReplacement(
            context,
            PageTransition(
              child: LoginInitScreen(),
              type: PageTransitionType.fade,
            ),
          );
        } else if (state is PosScreenSuccess) {
          Navigator.pop(context);
        }
      },
      child: BlocBuilder<PosScreenBloc, PosScreenState>(
        bloc: widget.screenBloc,
        builder: (BuildContext context, PosScreenState state) {
          return _body(state);
        },
      ),
    );
  }

  Widget _appBar(PosScreenState state) {
    return AppBar(
      centerTitle: false,
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.black87,
      title: Row(
        children: <Widget>[
          Text(
            'Terminals list',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      actions: <Widget>[
        IconButton(
          constraints: BoxConstraints(
              maxHeight: 32,
              maxWidth: 32,
              minHeight: 32,
              minWidth: 32
          ),
          icon: Icon(
            Icons.close,
            color: Colors.white,
            size: 24,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        Padding(
          padding: EdgeInsets.only(right: 16),
        ),
      ],
    );
  }

  Widget _body(PosScreenState state) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomPadding: false,
      appBar: _appBar(state),
      body: SafeArea(
        bottom: false,
        child: BackgroundBase(
          true,
          body: state.isLoading ?
          Center(
            child: CircularProgressIndicator(),
          ): Container(
            alignment: Alignment.center,
            child: Container(
              width: Measurements.width,
              child: _getBody(state),
            ),
          ),
        ),
      ),
    );
  }

  Widget _getBody(PosScreenState state) {
    List<Terminal> terminals = state.terminals;
    defaultTerminal = terminals.where((element) => element.active).first;
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          _activeTerminalWidget(state) ,
          Text(
            'Further Terminals',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 16),
          ),
          _furtherTerminals(state),
        ],
      ),
    );
  }

  Widget _activeTerminalWidget(PosScreenState state) {
    Terminal activeTerminal = state.activeTerminal;
    String avatarName = '';
    if (activeTerminal != null) {
      String name = activeTerminal.name;
      if (name.contains(' ')) {
        avatarName = name.substring(0, 1);
        avatarName = avatarName + name.split(' ')[1].substring(0, 1);
      } else {
        avatarName = name.substring(0, 1) + name.substring(name.length - 1);
        avatarName = avatarName.toUpperCase();
      }
    }
    return Container(
      padding: EdgeInsets.only(top: 64, bottom: 64),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              child: activeTerminal.logo != null ?
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blueGrey.withOpacity(0.5),
                  image: DecorationImage(
                    image: NetworkImage('$imageBase${activeTerminal.logo}'),
                    fit: BoxFit.cover,
                  ),
                ),
              ):
              Container(
                width: 100,
                height: 100,
                child: CircleAvatar(
                  backgroundColor: Colors.blueGrey.withOpacity(0.5),
                  child: Text(
                    avatarName,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 12),
            ),
            MaterialButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  PageTransition(
                    child: PosCreateTerminalScreen(
                      screenBloc: widget.screenBloc,
                    ),
                    type: PageTransitionType.fade,
                    duration: Duration(milliseconds: 500),
                  ),
                );
              },
              height: 32,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: overlayBackground(),
              child: Text(
                '+ Add Terminal',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _furtherTerminals(PosScreenState state) {
    return GridView.count(
      crossAxisCount: _isTablet ? 5: 3,
      childAspectRatio: 0.7,
      padding: EdgeInsets.only(left: 8, right: 8, bottom: 24),
      shrinkWrap: true,
      children: state.terminals.map((ter) => TerminalCell(
        onTap: (Terminal tn){
          setState(() {
            selectedTerminal = tn;
          });
        },
        selected: selectedTerminal,
        terminal: ter,
        onMore: (Terminal tn) {
          showCupertinoModalPopup(
            context: context,
            builder: (builder) {
              bool isDefault = tn.id == defaultTerminal.id;
              return Container(
                height: 64.0 * (isDefault ? 1.0 : 3.0) + MediaQuery.of(context).padding.bottom,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                padding: EdgeInsets.only(top: 16),
                child: Column(
                  children: popupButtons(context, tn).sublist(0, isDefault ? 1 : 3),
                ),
              );
            },
          );
        },
        onOpen: (Terminal tn) {
          widget.screenBloc.add(SetActiveTerminalEvent(activeTerminal: tn));
          Navigator.pop(context);
        },
      )).toList(),
      physics: NeverScrollableScrollPhysics(),
    );
  }

  List<Widget> popupButtons(BuildContext context, Terminal terminal) {
    return [
      Container(
        height: 44,
        child: SizedBox.expand(
          child: MaterialButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                PageTransition(
                  child: PosCreateTerminalScreen(
                    screenBloc: widget.screenBloc,
                    editTerminal: terminal,
                  ),
                  type: PageTransitionType.fade,
                  duration: Duration(milliseconds: 500),
                ),
              );
            },
            child: Text('Edit'),
          ),
        ),
      ),
      Container(
        height: 44,
        child: SizedBox.expand(
          child: MaterialButton(
            onPressed: () {
              Navigator.pop(context);
              widget.screenBloc.add(SetDefaultTerminalEvent(activeTerminal: terminal));
            },
            child: Text('Set as Default'),
          ),
        ),
      ),
      Container(
        height: 44,
        child: SizedBox.expand(
          child: MaterialButton(
            onPressed: () {
              Navigator.pop(context);
              showCupertinoDialog(
                context: context,
                builder: (builder) {
                  return Dialog(
                    backgroundColor: Colors.transparent,
                    child: Container(
                      height: 250,
                      child: BlurEffectView(
                        color: Color.fromRGBO(50, 50, 50, 0.4),
                        padding: EdgeInsets.all(16),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(top: 16),
                            ),
                            Icon(Icons.info),
                            Padding(
                              padding: EdgeInsets.only(top: 16),
                            ),
                            Text(
                              Language.getPosStrings('delete_terminal_confirm.title'),
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.white
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 16),
                            ),
                            Text(
                              Language.getPosStrings('delete_terminal_confirm.description'),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.white
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
                                  child: Text(
                                    'No',
                                  ),
                                ),
                                MaterialButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    widget.screenBloc.add(DeleteTerminalEvent(activeTerminal: terminal));
                                  },
                                  child: Text(
                                    'Yes',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
            child: Text('Delete'),
          ),
        ),
      ),
    ];
  }
}

class TerminalCell extends StatelessWidget {
  final Function onTap;
  final Terminal terminal;
  final Terminal selected;
  final Function onOpen;
  final Function onMore;

  TerminalCell({
    this.onTap,
    this.terminal,
    this.selected,
    this.onOpen,
    this.onMore
  });

  @override
  Widget build(BuildContext context) {
    String avatarName = '';
    String name = terminal.name;
    if (name.contains(' ')) {
      avatarName = name.substring(0, 1);
      avatarName = avatarName.toUpperCase() + name.split(' ')[1].substring(0, 1).toUpperCase();
    } else {
      avatarName = name.substring(0, 1) + name.substring(name.length - 1).toUpperCase();
      avatarName = avatarName.toUpperCase();
    }
    return MaterialButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      elevation: 0,
      focusElevation: 0,
      hoverElevation: 0,
      highlightElevation: 0,
      color: selected.id == terminal.id ? overlayBackground().withOpacity(0.5) : Colors.transparent.withOpacity(0),
      onPressed: () {
        onTap(terminal);
      },
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              child: terminal.logo != null ?
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage('$imageBase${terminal.logo}'),
                    fit: BoxFit.cover,
                  ),
                ),
              ):
              Container(
                width: 80,
                height: 80,
                child: CircleAvatar(
                  backgroundColor: Colors.blueGrey.withOpacity(0.5),
                  child: Text(
                    avatarName,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 12),
            ),
            Text(
              terminal.name,
              maxLines: 2,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            Container(
              height: 36,
              child: selected.id == terminal.id ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      onOpen(terminal);
                    },
                    child: Container(
                      height: 20,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: overlayBackground(),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'Open',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      onMore(terminal);
                    },
                    child: Container(
                      height: 20,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.more_horiz,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ): Container(),
            ),
          ],
        ),
      ),
    );
  }
}
