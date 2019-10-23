import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/common/component_index.dart';
import 'package:flutter_wanandroid/ui/pages/language_page.dart';

class SettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    LogUtil.e("SettingPage build......");
    final ApplicationBloc bloc = BlocProvider.of<ApplicationBloc>(context);
    LanguageModel languageModel =
        SpHelper.getObject<LanguageModel>(Constant.keyLanguage);
    return new Scaffold(
      appBar: AppBar(
        title: Text(
          IntlUtil.getString(context, Ids.titleSetting),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          /// https://flutterchina.club/catalog/samples/expansion-tile-sample/
          /// 扩展瓦片，可以进行展开，折叠的控件
          new ExpansionTile(
            title: new Row(
              children: <Widget>[
                Icon(
                  Icons.color_lens,
                  color: Colours.gray_66,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Text(
                    IntlUtil.getString(context, Ids.titleTheme),
                  ),
                )
              ],
            ),
            children: <Widget>[
              // Wrap: 类比FlexBox，自适应行列空间不足的换行
              new Wrap(
                children: themeColorMap.keys.map((String key) {
                  Color value = themeColorMap[key];
                  return new InkWell(
                    onTap: () {
                      SpUtil.putString(Constant.key_theme_color, key);
                      bloc.sendAppEvent(Constant.type_sys_update);
                    },
                    child: new Container(
                      margin: EdgeInsets.all(5.0),
                      width: 36.0,
                      height: 36.0,
                      color: value,
                    ),
                  );
                }).toList(),
              )
            ],
          ),
          // 列表瓦片
          new ListTile(
            title: new Row(
              children: <Widget>[
                Icon(
                  Icons.language,
                  color: Colours.gray_66,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Text(
                    IntlUtil.getString(context, Ids.titleLanguage),
                  ),
                )
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                    languageModel == null
                        ? IntlUtil.getString(context, Ids.languageAuto)
                        : IntlUtil.getString(context, languageModel.titleId,
                            languageCode: 'zh', countryCode: 'CH'),
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colours.gray_99,
                    )),
                Icon(Icons.keyboard_arrow_right)
              ],
            ),
            onTap: () {
              NavigatorUtil.pushPage(context, LanguagePage(),
                  pageName: Ids.titleLanguage);
            },
          )
        ],
      ),
    );
  }
}
