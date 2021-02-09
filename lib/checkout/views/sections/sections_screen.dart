import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/checkout/models/models.dart';
import 'package:payever/checkout/widgets/section_item.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';
import 'package:payever/commons/views/custom_elements/custom_elements.dart';
import 'package:payever/settings/widgets/app_bar.dart';
import 'package:payever/theme.dart';

class SectionsScreen extends StatefulWidget {
  final CheckoutScreenBloc screenBloc;

  SectionsScreen(this.screenBloc);

  @override
  _SectionsScreenState createState() => _SectionsScreenState(screenBloc);
}

class _SectionsScreenState extends State<SectionsScreen> {
  final CheckoutScreenBloc screenBloc;

  bool isExpandedSection1 = false;
  bool isExpandedSection2 = false;
  bool isExpandedSection3 = false;

  _SectionsScreenState(this.screenBloc);

  @override
  void initState() {
    screenBloc.add(GetSectionDetails());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CheckoutScreenBloc, CheckoutScreenState>(
      bloc: screenBloc,
      builder: (BuildContext context, state) {
        return Scaffold(
            appBar: Appbar('Sections'),
            body: SafeArea(
                bottom: false,
                child: BackgroundBase(true,
                    body: state.addSection == 0
                        ? _getBody(state)
                        : _getAddSectionWidget(state))));
      },
    );
  }

  Widget _getBody(CheckoutScreenState state) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Center(
        child: Container(
          width: GlobalUtils.mainWidth,
          child: BlurEffectView(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SectionItem(
                    title: 'Step 1',
                    detail: 'Shopping cart details',
                    isExpanded: isExpandedSection1,
                    onTap: () {
                      setState(() {
                        isExpandedSection1 = !isExpandedSection1;
                      });
                    },
                    sections: state.sections1,
                    onReorder: (oldIndex, newIndex) {
                      screenBloc.add(ReorderSection1Event(
                          oldIndex: oldIndex, newIndex: newIndex));
                    },
                    onDelete: (Section section) {
                      screenBloc.add(RemoveSectionEvent(section: section));
                    },
                    onEdit: () {
                      screenBloc.add(AddSectionEvent(section: 1));
                    },
                  ),
                  Divider(
                    height: 0,
                    thickness: 0.5,
                    color: Colors.grey,
                  ),
                  SectionItem(
                    title: 'Step 2',
                    detail: 'Customer & payment details',
                    isExpanded: isExpandedSection2,
                    onTap: () {
                      setState(() {
                        isExpandedSection2 = !isExpandedSection2;
                      });
                    },
                    sections: state.sections2,
                    onReorder: (oldIndex, newIndex) {
                      screenBloc.add(ReorderSection2Event(
                          oldIndex: oldIndex, newIndex: newIndex));
                    },
                    onDelete: (Section section) {
                      screenBloc.add(RemoveSectionEvent(section: section));
                    },
                    onEdit: () {
                      screenBloc.add(AddSectionEvent(section: 2));
                    },
                  ),
                  Divider(
                    height: 0,
                    thickness: 0.5,
                    color: Colors.grey,
                  ),
                  SectionItem(
                    title: 'Step 3',
                    detail: 'After sale details',
                    isExpanded: isExpandedSection3,
                    onTap: () {
                      setState(() {
                        isExpandedSection3 = !isExpandedSection3;
                      });
                    },
                    sections: [],
                    onReorder: (oldIndex, newIndex) {
                      screenBloc.add(ReorderSection3Event(
                          oldIndex: oldIndex, newIndex: newIndex));
                    },
                    onDelete: (Section section) {},
                    onEdit: () {},
                  ),
                  Divider(
                    height: 0,
                    thickness: 0.5,
                    color: Colors.grey,
                  ),
                  Container(
                    height: 65,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                    ),
                    child: state.sectionUpdate
                        ? Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : MaterialButton(
                            onPressed: () {
                              screenBloc.add(UpdateCheckoutSections());
                            },
                            color: overlayBackground(),
                            child: Text(
                              'Save',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _getAddSectionWidget(CheckoutScreenState state) {
    List<Section> sections = state.addSection == 1
        ? state.availableSections1
        : state.availableSections2;
    return Container(
      width: Measurements.width,
      padding: EdgeInsets.all(16),
      child: Center(
        child: BlurEffectView(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  height: 50,
                  color: Colors.black54,
                  padding: EdgeInsets.only(
                    left: 16,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Sections',
                      ),
                      CloseButton(
                        onPressed: () {
                          screenBloc.add(AddSectionEvent(section: 0));
                        },
                      )
                    ],
                  ),
                ),
                sections.length == 0
                    ? Container(
                        height: 50,
                        padding: EdgeInsets.only(left: 16),
                        child: Row(
                          children: <Widget>[
                            Text(
                              'No available sections',
                            ),
                          ],
                        ),
                      )
                    : ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Container(
                            height: 50,
                            child: SizedBox.expand(
                              child: MaterialButton(
                                onPressed: () {
                                  screenBloc.add(AddSectionToStepEvent(
                                      section: sections[index],
                                      step: state.addSection));
                                },
                                child: Row(
                                  children: <Widget>[
                                    Icon(Icons.add),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Text(
                                      getTitleFromCode(sections[index].code),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return Divider(
                            color: Colors.transparent,
                            height: 0,
                          );
                        },
                        itemCount: sections.length,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
