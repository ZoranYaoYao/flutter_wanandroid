import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/common/component_index.dart';
// 主页-体系Tab-item
class TreeItem extends StatelessWidget {
  const TreeItem(this.model, {Key key}) : super(key: key);

  final TreeModel model;

  @override
  Widget build(BuildContext context) {
    final List<Widget> chips = model.children.map<Widget>((TreeModel _model) {
      /// Chip 碎片，标签组件
      // https://www.jianshu.com/p/b345d45b1453
      return Chip(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        key: ValueKey<String>(_model.name),
        backgroundColor: Utils.getChipBgColor(_model.name),
        label: Text(
          _model.name,
          style: new TextStyle(fontSize: 14.0),
        ),
      );
    }).toList();

    return new InkWell(
      onTap: () {
        //LogUtil.e("ReposModel: " + model.toString());
        NavigatorUtil.pushTabPage(context,
            labelId: Ids.titleSystemTree, title: model.name, treeModel: model);
      },
      child: new _ChipsTile(
        label: model.name,
        children: chips,
      ),
    );
  }
}

class _ChipsTile extends StatelessWidget {
  const _ChipsTile({
    Key key,
    this.label,
    this.children,
  }) : super(key: key);

  final String label;
  final List<Widget> children;

  // Wraps a list of chips into a ListTile for display as a section in the demo.
  @override
  Widget build(BuildContext context) {
    final List<Widget> cardChildren = <Widget>[
      new Text(
        label,
        style: TextStyles.listTitle,
      ),
      Gaps.vGap10
    ];
    /// Wrap组件 row水平方向自动折行
    /// https://book.flutterchina.club/chapter4/wrap_and_flow.html
    cardChildren.add(Wrap(
        children: children.map((Widget chip) {
      return Padding(
        padding: const EdgeInsets.all(3.0),
        child: chip,
      );
    }).toList()));

    return new Container(
      padding: EdgeInsets.all(16.0),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: cardChildren,
      ),
      decoration: new BoxDecoration(
          color: Colors.white,
          border: new Border(
              bottom: new BorderSide(width: 0.33, color: Colours.divider))),
    );
  }
}
