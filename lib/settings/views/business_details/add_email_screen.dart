import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/commons/view_models/global_state_model.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/views/custom_elements/wallpaper.dart';
import 'package:payever/settings/widgets/app_bar.dart';
import 'package:payever/settings/widgets/save_button.dart';
import 'package:payever/theme.dart';

class AddEmailScreen extends StatefulWidget {
  final GlobalStateModel globalStateModel;
  final SettingScreenBloc setScreenBloc;
  final String editEmail;
  final List<String> contactEmails;

  AddEmailScreen({
    this.globalStateModel,
    this.setScreenBloc,
    this.editEmail,
    this.contactEmails = const [],
  });

  @override
  _AddEmailScreenState createState() => _AddEmailScreenState();
}

class _AddEmailScreenState extends State<AddEmailScreen> {

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String email;
  int index = -1;
  @override
  void initState() {
    if (widget.editEmail != null) {
      email = widget.editEmail;
      index = widget.contactEmails.indexOf(email);
    }
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
    return Scaffold(
      appBar: Appbar(Language.getSettingsStrings(widget.editEmail != null ?
      'form.create_form.contact_email.edit_contact_email':
      'form.create_form.contact_email.new_contact_email')),
      body: SafeArea(
        bottom: false,
        child: BackgroundBase(
          true,
          body: _updateForm,
        ),
      ),
    );
  }

  get _updateForm {
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
          return Form(
            key: formKey,
            child: Center(
              child: Container(
                width: Measurements.width,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Stack(
                    children: [
                      Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Container(
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                color: overlayColor(),
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8.0),
                                  topRight: Radius.circular(8.0),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Center(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: overlayRow(),
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: TextFormField(
                                      validator: (val) {
                                        if (val.isEmpty) {
                                          return 'Email address required';
                                        } else  if (!Validators.isValidEmail(val)) {
                                          return 'Email address invalid';
                                        } else {
                                          return null;
                                        }
                                      },
                                      initialValue: email,
                                      onChanged: (val) {
                                        setState(() {
                                          email = val;
                                        });
                                      },
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        labelText: Language.getSettingsStrings('form.create_form.contact_email.contact_email.label'),
                                        contentPadding: EdgeInsets.all(16),
                                      ),
                                      onFieldSubmitted: (val) {
                                        if (formKey.currentState.validate()) {
                                          List<String> contactEmails = [];
                                          contactEmails.addAll(widget.contactEmails);
                                          if (widget.editEmail != null) {
                                            contactEmails[index] = email;
                                          } else {
                                            contactEmails.add(email);
                                          }
                                          widget.setScreenBloc.add(BusinessUpdateEvent({
                                            'contactEmails': contactEmails,
                                          }));
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SaveBtn(
                              isUpdating: state.isUpdating,
                              onUpdate: () {
                                if (formKey.currentState.validate()) {
                                  List<String> contactEmails = [];
                                  contactEmails.addAll(widget.contactEmails);
                                  if (widget.editEmail != null) {
                                    contactEmails[index] = email;
                                  } else {
                                    contactEmails.add(email);
                                  }
                                  widget.setScreenBloc.add(BusinessUpdateEvent({
                                    'contactEmails': contactEmails,
                                  })
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
