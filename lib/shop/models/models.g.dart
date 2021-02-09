// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShopModel _$ShopModelFromJson(Map<String, dynamic> json) {
  return ShopModel()
    ..active = json['active'] as bool
    ..business = json['business'] as String
    ..channelSet = json['channelSet'] as String
    ..createdAt = json['createdAt'] as String
    ..defaultLocale = json['defaultLocale'] as String
    ..id = json['id'] as String
    ..live = json['live'] as bool
    ..locales = (json['locales'] as List)?.map((e) => e as String)?.toList()
    ..logo = json['logo'] as String
    ..name = json['name'] as String
    ..password = json['password'] == null
        ? null
        : PasswordModel.fromJson(json['password'] as Map<String, dynamic>)
    ..updatedAt = json['updatedAt'] as String;
}

Map<String, dynamic> _$ShopModelToJson(ShopModel instance) => <String, dynamic>{
      'active': instance.active,
      'business': instance.business,
      'channelSet': instance.channelSet,
      'createdAt': instance.createdAt,
      'defaultLocale': instance.defaultLocale,
      'id': instance.id,
      'live': instance.live,
      'locales': instance.locales,
      'logo': instance.logo,
      'name': instance.name,
      'password': instance.password,
      'updatedAt': instance.updatedAt,
    };

PasswordModel _$PasswordModelFromJson(Map<String, dynamic> json) {
  return PasswordModel()
    ..enabled = json['enabled'] as bool ?? false
    ..passwordLock = json['passwordLock'] as bool ?? false
    ..id = json['_id'] as String;
}

Map<String, dynamic> _$PasswordModelToJson(PasswordModel instance) =>
    <String, dynamic>{
      'enabled': instance.enabled,
      'passwordLock': instance.passwordLock,
      '_id': instance.id,
    };

TemplateModel _$TemplateModelFromJson(Map<String, dynamic> json) {
  return TemplateModel()
    ..code = json['code'] as String
    ..icon = json['icon'] as String
    ..id = json['id'] as String
    ..items = (json['items'] as List)
        ?.map((e) => e == null
            ? null
            : ThemeItemModel.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..order = json['order'] as int;
}

Map<String, dynamic> _$TemplateModelToJson(TemplateModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'icon': instance.icon,
      'id': instance.id,
      'items': instance.items,
      'order': instance.order,
    };

ThemeItemModel _$ThemeItemModelFromJson(Map<String, dynamic> json) {
  return ThemeItemModel()
    ..code = json['code'] as String
    ..groupId = json['groupId'] as String
    ..id = json['id'] as String
    ..themes = (json['themes'] as List)
        ?.map((e) =>
            e == null ? null : ThemeModel.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..type = json['type'] as String;
}

Map<String, dynamic> _$ThemeItemModelToJson(ThemeItemModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'groupId': instance.groupId,
      'id': instance.id,
      'themes': instance.themes,
      'type': instance.type,
    };

ThemeModel _$ThemeModelFromJson(Map<String, dynamic> json) {
  return ThemeModel()
    ..id = json['id'] as String
    ..application = json['application'] as String
    ..isActive = json['isActive'] as bool ?? false
    ..isDeployed = json['isDeployed'] as bool ?? false
    ..name = json['name'] as String
    ..picture = json['picture'] as String
    ..shopId = json['shopId'] as String
    ..themeId = json['theme'] as String
    ..type = json['type'] as String;
}

Map<String, dynamic> _$ThemeModelToJson(ThemeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'application': instance.application,
      'isActive': instance.isActive,
      'isDeployed': instance.isDeployed,
      'name': instance.name,
      'picture': instance.picture,
      'shopId': instance.shopId,
      'theme': instance.themeId,
      'type': instance.type,
    };

ShopDetailModel _$ShopDetailModelFromJson(Map<String, dynamic> json) {
  return ShopDetailModel()
    ..id = json['id'] as String
    ..accessConfig = json['accessConfig'] == null
        ? null
        : AccessConfig.fromJson(json['accessConfig'] as Map<String, dynamic>)
    ..business = json['business'] == null
        ? null
        : BusinessM.fromJson(json['business'] as Map<String, dynamic>)
    ..channelSet = json['channelSet'] == null
        ? null
        : ChannelSet.fromJson(json['channelSet'] as Map<String, dynamic>)
    ..isDefault = json['isDefault'] as bool ?? false
    ..name = json['name'] as String
    ..picture = json['picture'] as String;
}

Map<String, dynamic> _$ShopDetailModelToJson(ShopDetailModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'accessConfig': instance.accessConfig,
      'business': instance.business,
      'channelSet': instance.channelSet,
      'isDefault': instance.isDefault,
      'name': instance.name,
      'picture': instance.picture,
    };

AccessConfig _$AccessConfigFromJson(Map<String, dynamic> json) {
  return AccessConfig()
    ..id = json['id'] as String
    ..internalDomain = json['internalDomain'] as String
    ..internalDomainPattern = json['internalDomainPattern'] as String
    ..isLive = json['isLive'] as bool
    ..isLocked = json['isLocked'] as bool
    ..isPrivate = json['isPrivate'] as bool
    ..ownDomain = json['ownDomain'] as String
    ..privateMessage = json['privateMessage'] as String
    ..privatePassword = json['privatePassword'] as String;
}

Map<String, dynamic> _$AccessConfigToJson(AccessConfig instance) =>
    <String, dynamic>{
      'id': instance.id,
      'internalDomain': instance.internalDomain,
      'internalDomainPattern': instance.internalDomainPattern,
      'isLive': instance.isLive,
      'isLocked': instance.isLocked,
      'isPrivate': instance.isPrivate,
      'ownDomain': instance.ownDomain,
      'privateMessage': instance.privateMessage,
      'privatePassword': instance.privatePassword,
    };

BusinessM _$BusinessMFromJson(Map<String, dynamic> json) {
  return BusinessM()
    ..id = json['id'] as String
    ..name = json['name'] as String;
}

Map<String, dynamic> _$BusinessMToJson(BusinessM instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };

ThemeResponse _$ThemeResponseFromJson(Map<String, dynamic> json) {
  return ThemeResponse()
    ..id = json['id'] as String
    ..name = json['name'] as String
    ..picture = json['picture'] as String
    ..published = json['published']
    ..source = json['source'] as String
    ..type = json['type'] as String
    ..versions = json['versions'] as List;
}

Map<String, dynamic> _$ThemeResponseToJson(ThemeResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'picture': instance.picture,
      'published': instance.published,
      'source': instance.source,
      'type': instance.type,
      'versions': instance.versions,
    };

ShopPage _$ShopPageFromJson(Map<String, dynamic> json) {
  return ShopPage()
    ..contextId = json['contextId'] as String
    ..data = json['data'] == null
        ? null
        : PageData.fromJson(json['data'] as Map<String, dynamic>)
    ..id = json['id'] as String
    ..name = json['name'] as String
    ..stylesheetIds = json['stylesheetIds'] == null
        ? null
        : StyleSheetIds.fromJson(json['stylesheetIds'] as Map<String, dynamic>)
    ..templateId = json['templateId'] as String
    ..type = json['type'] as String
    ..variant = json['variant'] as String;
}

Map<String, dynamic> _$ShopPageToJson(ShopPage instance) => <String, dynamic>{
      'contextId': instance.contextId,
      'data': instance.data,
      'id': instance.id,
      'name': instance.name,
      'stylesheetIds': instance.stylesheetIds,
      'templateId': instance.templateId,
      'type': instance.type,
      'variant': instance.variant,
    };

PageData _$PageDataFromJson(Map<String, dynamic> json) {
  return PageData()..preview = json['preview'] as String;
}

Map<String, dynamic> _$PageDataToJson(PageData instance) => <String, dynamic>{
      'preview': instance.preview,
    };

StyleSheetIds _$StyleSheetIdsFromJson(Map<String, dynamic> json) {
  return StyleSheetIds()
    ..desktop = json['desktop'] as String
    ..mobile = json['mobile'] as String
    ..tablet = json['tablet'] as String;
}

Map<String, dynamic> _$StyleSheetIdsToJson(StyleSheetIds instance) =>
    <String, dynamic>{
      'desktop': instance.desktop,
      'mobile': instance.mobile,
      'tablet': instance.tablet,
    };

Action _$ActionFromJson(Map<String, dynamic> json) {
  return Action()
    ..affectedPageIds =
        (json['affectedPageIds'] as List)?.map((e) => e as String)?.toList()
    ..createdAt = json['createdAt'] as String
    ..effects = (json['effects'] as List)
        ?.map((e) =>
            e == null ? null : Effect.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..id = json['id'] as String
    ..targetPageId = json['targetPageId'] as String;
}

Map<String, dynamic> _$ActionToJson(Action instance) => <String, dynamic>{
      'affectedPageIds': instance.affectedPageIds,
      'createdAt': instance.createdAt,
      'effects': instance.effects,
      'id': instance.id,
      'targetPageId': instance.targetPageId,
    };

Effect _$EffectFromJson(Map<String, dynamic> json) {
  return Effect()
    ..payload = json['payload'] == null
        ? null
        : Payload.fromJson(json['payload'] as Map<String, dynamic>)
    ..target = json['target'] as String
    ..type = json['type'] as String;
}

Map<String, dynamic> _$EffectToJson(Effect instance) => <String, dynamic>{
      'payload': instance.payload,
      'target': instance.target,
      'type': instance.type,
    };

Payload _$PayloadFromJson(Map<String, dynamic> json) {
  return Payload()
    ..children = json['children'] as List
    ..data = json['data'] == null
        ? null
        : PayloadData.fromJson(json['data'] as Map<String, dynamic>)
    ..id = json['id'] as String
    ..meta = json['meta']
    ..type = json['type'] as String;
}

Map<String, dynamic> _$PayloadToJson(Payload instance) => <String, dynamic>{
      'children': instance.children,
      'data': instance.data,
      'id': instance.id,
      'meta': instance.meta,
      'type': instance.type,
    };

PayloadData _$PayloadDataFromJson(Map<String, dynamic> json) {
  return PayloadData()
    ..sync = json['sync'] as bool
    ..text = json['text'] as String;
}

Map<String, dynamic> _$PayloadDataToJson(PayloadData instance) =>
    <String, dynamic>{
      'sync': instance.sync,
      'text': instance.text,
    };

Template _$TemplateFromJson(Map<String, dynamic> json) {
  return Template()
    ..children = (json['children'] as List)
        ?.map(
            (e) => e == null ? null : Child.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..id = json['id'] as String
    ..type = json['type'] as String;
}

Map<String, dynamic> _$TemplateToJson(Template instance) => <String, dynamic>{
      'children': instance.children,
      'id': instance.id,
      'type': instance.type,
    };

Child _$ChildFromJson(Map<String, dynamic> json) {
  return Child()
    ..children = (json['children'] as List)
        ?.map(
            (e) => e == null ? null : Child.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..childrenRefs = json['childrenRefs']
    ..context = json['context'] == null
        ? null
        : Context.fromJson(json['context'] as Map<String, dynamic>)
    ..id = json['id'] as String
    ..meta = json['meta'] == null
        ? null
        : Meta.fromJson(json['meta'] as Map<String, dynamic>)
    ..parent = json['parent'] == null
        ? null
        : Parent.fromJson(json['parent'] as Map<String, dynamic>)
    ..styles = json['styles'] as Map<String, dynamic>
    ..type = json['type'] as String
    ..data = json['data'];
}

Map<String, dynamic> _$ChildToJson(Child instance) => <String, dynamic>{
      'children': instance.children,
      'childrenRefs': instance.childrenRefs,
      'context': instance.context,
      'id': instance.id,
      'meta': instance.meta,
      'parent': instance.parent,
      'styles': instance.styles,
      'type': instance.type,
      'data': instance.data,
    };

Context _$ContextFromJson(Map<String, dynamic> json) {
  return Context()
    ..data = json['data']
    ..state = json['state'] as String;
}

Map<String, dynamic> _$ContextToJson(Context instance) => <String, dynamic>{
      'data': instance.data,
      'state': instance.state,
    };

Meta _$MetaFromJson(Map<String, dynamic> json) {
  return Meta()..deletable = json['deletable'] as bool;
}

Map<String, dynamic> _$MetaToJson(Meta instance) => <String, dynamic>{
      'deletable': instance.deletable,
    };

Parent _$ParentFromJson(Map<String, dynamic> json) {
  return Parent()
    ..id = json['id'] as String
    ..slot = json['slot'] as String;
}

Map<String, dynamic> _$ParentToJson(Parent instance) => <String, dynamic>{
      'id': instance.id,
      'slot': instance.slot,
    };

TextStyles _$TextStylesFromJson(Map<String, dynamic> json) {
  return TextStyles()
    ..display = json['display'] as String ?? 'flex'
    ..color = json['color'] as String ?? '#000000'
    ..fontSize = json['fontSize'] ?? 0
    ..fontWeight = json['fontWeight'] ?? 400
    ..fontFamily = json['fontFamily'] as String ??
        'Helvetica Neue,Helvetica,Arial,sans-serif'
    ..background = json['background'] as String ?? ''
    ..backgroundColor = json['backgroundColor'] as String ?? ''
    ..backgroundImage = json['backgroundImage'] as String ?? ''
    ..gridColumn = json['gridColumn'] as String ?? '1 / span 1'
    ..gridRow = json['gridRow'] as String ?? '1 / span 1'
    ..gridArea = json['gridArea']
    ..width = json['width'] ?? 0
    ..height = (json['height'] as num)?.toDouble() ?? 0
    ..minWidth = (json['minWidth'] as num)?.toDouble() ?? 0
    ..minHeight = (json['minHeight'] as num)?.toDouble() ?? 0
    ..margin = json['margin'] as String ?? '0 0 0 0'
    ..padding = json['padding'] as String ?? '8 28'
    ..position = json['position'] as String ?? 'absolute'
    ..marginBottom = (json['marginBottom'] as num)?.toDouble() ?? 0
    ..marginLeft = (json['marginLeft'] as num)?.toDouble() ?? 0
    ..marginRight = (json['marginRight'] as num)?.toDouble() ?? 0
    ..marginTop = (json['marginTop'] as num)?.toDouble() ?? 0
    ..top = (json['top'] as num)?.toDouble() ?? 0
    ..left = (json['left'] as num)?.toDouble() ?? 0;
}

Map<String, dynamic> _$TextStylesToJson(TextStyles instance) =>
    <String, dynamic>{
      'display': instance.display,
      'color': instance.color,
      'fontSize': instance.fontSize,
      'fontWeight': instance.fontWeight,
      'fontFamily': instance.fontFamily,
      'background': instance.background,
      'backgroundColor': instance.backgroundColor,
      'backgroundImage': instance.backgroundImage,
      'gridColumn': instance.gridColumn,
      'gridRow': instance.gridRow,
      'gridArea': instance.gridArea,
      'width': instance.width,
      'height': instance.height,
      'minWidth': instance.minWidth,
      'minHeight': instance.minHeight,
      'margin': instance.margin,
      'padding': instance.padding,
      'position': instance.position,
      'marginBottom': instance.marginBottom,
      'marginLeft': instance.marginLeft,
      'marginRight': instance.marginRight,
      'marginTop': instance.marginTop,
      'top': instance.top,
      'left': instance.left,
    };

ButtonStyles _$ButtonStylesFromJson(Map<String, dynamic> json) {
  return ButtonStyles()
    ..display = json['display'] as String ?? 'flex'
    ..background = json['background'] as String ?? '#ffffff'
    ..backgroundColor = json['backgroundColor'] as String ?? '#ffffff'
    ..backgroundImage = json['backgroundImage'] as String ?? ''
    ..color = json['color'] as String ?? '#ffffff'
    ..fontSize = (json['fontSize'] as num)?.toDouble() ?? 15
    ..fontWeight = json['fontWeight'] ?? 400
    ..fontFamily = json['fontFamily'] as String ??
        'Helvetica Neue,Helvetica,Arial,sans-serif'
    ..borderRadius = json['borderRadius'] ?? 0
    ..borderColor = json['borderColor'] as String ?? '#ffffff'
    ..borderWidth = (json['borderWidth'] as num)?.toDouble() ?? 0
    ..gridColumn = json['gridColumn'] as String ?? '1 / span 1'
    ..gridRow = json['gridRow'] as String ?? '1 / span 1'
    ..gridArea = json['gridArea']
    ..width = (json['width'] as num)?.toDouble() ?? 0
    ..height = (json['height'] as num)?.toDouble() ?? 0
    ..minWidth = (json['minWidth'] as num)?.toDouble() ?? 0
    ..minHeight = (json['minHeight'] as num)?.toDouble() ?? 0
    ..margin = json['margin'] as String ?? '0 0 0 0'
    ..padding = json['padding'] as String ?? '8 28'
    ..position = json['position'] as String ?? 'absolute'
    ..marginBottom = (json['marginBottom'] as num)?.toDouble() ?? 0
    ..marginLeft = (json['marginLeft'] as num)?.toDouble() ?? 0
    ..marginRight = (json['marginRight'] as num)?.toDouble() ?? 0
    ..marginTop = (json['marginTop'] as num)?.toDouble() ?? 0
    ..top = (json['top'] as num)?.toDouble() ?? 0
    ..left = (json['left'] as num)?.toDouble() ?? 0;
}

Map<String, dynamic> _$ButtonStylesToJson(ButtonStyles instance) =>
    <String, dynamic>{
      'display': instance.display,
      'background': instance.background,
      'backgroundColor': instance.backgroundColor,
      'backgroundImage': instance.backgroundImage,
      'color': instance.color,
      'fontSize': instance.fontSize,
      'fontWeight': instance.fontWeight,
      'fontFamily': instance.fontFamily,
      'borderRadius': instance.borderRadius,
      'borderColor': instance.borderColor,
      'borderWidth': instance.borderWidth,
      'gridColumn': instance.gridColumn,
      'gridRow': instance.gridRow,
      'gridArea': instance.gridArea,
      'width': instance.width,
      'height': instance.height,
      'minWidth': instance.minWidth,
      'minHeight': instance.minHeight,
      'margin': instance.margin,
      'padding': instance.padding,
      'position': instance.position,
      'marginBottom': instance.marginBottom,
      'marginLeft': instance.marginLeft,
      'marginRight': instance.marginRight,
      'marginTop': instance.marginTop,
      'top': instance.top,
      'left': instance.left,
    };

ImageStyles _$ImageStylesFromJson(Map<String, dynamic> json) {
  return ImageStyles()
    ..display = json['display'] as String ?? 'flex'
    ..background = json['background'] as String ?? ''
    ..backgroundColor = json['backgroundColor'] as String ?? '#ffffff'
    ..border = json['border']
    ..borderType = json['borderType'] as String ?? 'solid'
    ..borderRadius = (json['borderRadius'] as num)?.toDouble() ?? 0
    ..borderColor = json['borderColor'] as String ?? '#000000'
    ..borderSize = (json['borderSize'] as num)?.toDouble() ?? 0
    ..opacity = (json['opacity'] as num)?.toDouble() ?? 1
    ..boxShadow = json['boxShadow']
    ..shadowAngle = (json['shadowAngle'] as num)?.toDouble() ?? 0
    ..shadowBlur = (json['shadowBlur'] as num)?.toDouble() ?? 0
    ..shadowColor = json['shadowColor'] as String ?? 'rgba(0, 0, NaN, 0, 0)'
    ..shadowFormColor = json['shadowFormColor'] as String ?? '0, 0, 0'
    ..shadowOffset = (json['shadowOffset'] as num)?.toDouble() ?? 0
    ..shadowOpacity = (json['shadowOpacity'] as num)?.toDouble() ?? 0
    ..gridColumn = json['gridColumn'] as String ?? '1 / span 1'
    ..gridRow = json['gridRow'] as String ?? '1 / span 1'
    ..gridArea = json['gridArea']
    ..width = (json['width'] as num)?.toDouble() ?? 0
    ..height = (json['height'] as num)?.toDouble() ?? 0
    ..minWidth = (json['minWidth'] as num)?.toDouble() ?? 0
    ..minHeight = (json['minHeight'] as num)?.toDouble() ?? 0
    ..margin = json['margin'] as String ?? '0 0 0 0'
    ..padding = json['padding'] as String ?? '8 28'
    ..position = json['position'] as String ?? 'absolute'
    ..marginBottom = (json['marginBottom'] as num)?.toDouble() ?? 0
    ..marginLeft = (json['marginLeft'] as num)?.toDouble() ?? 0
    ..marginRight = (json['marginRight'] as num)?.toDouble() ?? 0
    ..marginTop = (json['marginTop'] as num)?.toDouble() ?? 0
    ..top = (json['top'] as num)?.toDouble() ?? 0
    ..left = (json['left'] as num)?.toDouble() ?? 0;
}

Map<String, dynamic> _$ImageStylesToJson(ImageStyles instance) =>
    <String, dynamic>{
      'display': instance.display,
      'background': instance.background,
      'backgroundColor': instance.backgroundColor,
      'border': instance.border,
      'borderType': instance.borderType,
      'borderRadius': instance.borderRadius,
      'borderColor': instance.borderColor,
      'borderSize': instance.borderSize,
      'opacity': instance.opacity,
      'boxShadow': instance.boxShadow,
      'shadowAngle': instance.shadowAngle,
      'shadowBlur': instance.shadowBlur,
      'shadowColor': instance.shadowColor,
      'shadowFormColor': instance.shadowFormColor,
      'shadowOffset': instance.shadowOffset,
      'shadowOpacity': instance.shadowOpacity,
      'gridColumn': instance.gridColumn,
      'gridRow': instance.gridRow,
      'gridArea': instance.gridArea,
      'width': instance.width,
      'height': instance.height,
      'minWidth': instance.minWidth,
      'minHeight': instance.minHeight,
      'margin': instance.margin,
      'padding': instance.padding,
      'position': instance.position,
      'marginBottom': instance.marginBottom,
      'marginLeft': instance.marginLeft,
      'marginRight': instance.marginRight,
      'marginTop': instance.marginTop,
      'top': instance.top,
      'left': instance.left,
    };

Data _$DataFromJson(Map<String, dynamic> json) {
  return Data()
    ..text = json['text'] as String
    ..action = json['action'] == null
        ? null
        : ChildAction.fromJson(json['action'] as Map<String, dynamic>)
    ..name = json['name'] as String
    ..src = json['src'] as String
    ..count = json['count'] as num
    ..product = json['product'] as Map<String, dynamic>;
}

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'text': instance.text,
      'action': instance.action,
      'name': instance.name,
      'src': instance.src,
      'count': instance.count,
      'product': instance.product,
    };

ChildAction _$ChildActionFromJson(Map<String, dynamic> json) {
  return ChildAction()
    ..type = json['type'] as String
    ..payload = json['payload'] as String;
}

Map<String, dynamic> _$ChildActionToJson(ChildAction instance) =>
    <String, dynamic>{
      'type': instance.type,
      'payload': instance.payload,
    };

SectionStyleSheet _$SectionStyleSheetFromJson(Map<String, dynamic> json) {
  return SectionStyleSheet()
    ..display = json['display'] as String ?? 'flex'
    ..backgroundColor = json['backgroundColor'] as String ?? '#ffffff'
    ..backgroundImage = json['backgroundImage'] as String ?? ''
    ..backgroundSize = json['backgroundSize'] as String
    ..backgroundPosition = json['backgroundPosition'] as String ?? 'center'
    ..backgroundRepeat = json['backgroundRepeat'] as String ?? 'no-repeat'
    ..gridTemplateRows = json['gridTemplateRows'] as String ?? '0 0 0'
    ..gridTemplateColumns = json['gridTemplateColumns'] as String ?? '0 0 0'
    ..gridRow = json['gridRow'] as String ?? '1 / span 1'
    ..gridColumn = json['gridColumn'] as String ?? '1 / span 1'
    ..width = (json['width'] as num)?.toDouble() ?? 0
    ..height = (json['height'] as num)?.toDouble() ?? 0
    ..margin = json['margin'] as String ?? '0 0 0 0'
    ..marginTop = (json['marginTop'] as num)?.toDouble() ?? 0
    ..marginRight = (json['marginRight'] as num)?.toDouble() ?? 0
    ..marginBottom = (json['marginBottom'] as num)?.toDouble() ?? 0
    ..marginLeft = (json['marginLeft'] as num)?.toDouble() ?? 0
    ..position = json['position'] as String ?? 'absolute'
    ..top = (json['top'] as num)?.toDouble() ?? 0
    ..zIndex = json['zIndex'];
}

Map<String, dynamic> _$SectionStyleSheetToJson(SectionStyleSheet instance) =>
    <String, dynamic>{
      'display': instance.display,
      'backgroundColor': instance.backgroundColor,
      'backgroundImage': instance.backgroundImage,
      'backgroundSize': instance.backgroundSize,
      'backgroundPosition': instance.backgroundPosition,
      'backgroundRepeat': instance.backgroundRepeat,
      'gridTemplateRows': instance.gridTemplateRows,
      'gridTemplateColumns': instance.gridTemplateColumns,
      'gridRow': instance.gridRow,
      'gridColumn': instance.gridColumn,
      'width': instance.width,
      'height': instance.height,
      'margin': instance.margin,
      'marginTop': instance.marginTop,
      'marginRight': instance.marginRight,
      'marginBottom': instance.marginBottom,
      'marginLeft': instance.marginLeft,
      'position': instance.position,
      'top': instance.top,
      'zIndex': instance.zIndex,
    };
