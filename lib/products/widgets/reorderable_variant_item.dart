import 'package:flutter/material.dart';
import 'package:payever/commons/utils/reorderable_list.dart';


class ReorderableVariantItem extends StatelessWidget {
  ReorderableVariantItem({
    @required Key key,
    @required this.innerItem,
    this.childrenAlreadyHaveListener = false,
    this.handleIcon,
  }) : super(key: key);

  final bool childrenAlreadyHaveListener;
  final Icon handleIcon;
  final Widget innerItem;

  Color _iconColor(ThemeData theme, ListTileTheme tileTheme) {
    if (tileTheme?.selectedColor != null)
      return tileTheme.selectedColor;

    if (tileTheme?.iconColor != null)
      return tileTheme.iconColor;

    switch (theme.brightness) {
      case Brightness.light:
        return theme.primaryColor;
      case Brightness.dark:
        return theme.accentColor;
    }
    assert(theme.brightness != null);
    return null;
  }

  Widget _buildInnerItem(BuildContext context) {
    assert(innerItem != null);

    if (childrenAlreadyHaveListener) return innerItem;

    Icon icon = handleIcon;
    if (icon == null) icon = Icon(Icons.drag_handle);

    var item = Expanded(child: innerItem);
    List<Widget> children = <Widget>[];

    children.add(item);
    children.add(ReorderableListener(
      child: Container(
          alignment: Alignment.centerLeft,
          child: icon
      ),
    ));

    final Row row = Row(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: children,
    );

    final ThemeData theme = Theme.of(context);
    final ListTileTheme tileTheme = ListTileTheme.of(context);

    return IconTheme.merge(
      data: IconThemeData(color: _iconColor(theme, tileTheme)),
      child: row,
    );
  }

  BoxDecoration _decoration(BuildContext context, ReorderableItemState state) {
    if (state == ReorderableItemState.dragProxy ||
        state == ReorderableItemState.dragProxyFinished) {
      return BoxDecoration(color: Color(0x40808080));
    } else {
      bool placeholder = state == ReorderableItemState.placeholder;
      return BoxDecoration(
          border: Border(
              top: !placeholder
                  ? Divider.createBorderSide(context)
                  : BorderSide.none,
              bottom: placeholder
                  ? BorderSide.none
                  : Divider.createBorderSide(context)),
          color: placeholder ? null : Colors.transparent);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ReorderableItem(
      key: key,
      childBuilder: (BuildContext context, ReorderableItemState state) {
        BoxDecoration decoration = _decoration(context, state);
        return Container(
          decoration: decoration,
          child: Opacity(
            opacity: state == ReorderableItemState.placeholder ? 0.0 : 1.0,
            child: _buildInnerItem(context),
          ),
        );
      },
    );
  }
}