import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/common/component_index.dart';
import 'package:flutter_wanandroid/ui/pages/rec_hot_page.dart';

bool isHomeInit = true;

class HomePage extends StatelessWidget {
  const HomePage({Key key, this.labelId}) : super(key: key);

  final String labelId;

  Widget buildBanner(BuildContext context, List<BannerModel> list) {
    if (ObjectUtil.isEmpty(list)) {
      return new Container(height: 0.0);
    }
    // 宽高比组件
    // https://juejin.im/post/5cefce50f265da1bc14b0db3
    return new AspectRatio(
      aspectRatio: 16.0 / 9.0,
      // Swiper 滑动控件
      child: Swiper(
        // 指示器位置
        indicatorAlignment: AlignmentDirectional.topEnd,
        circular: true,
        interval: const Duration(seconds: 5),
        // 指示器
        indicator: NumberSwiperIndicator(),
        children: list.map((model) {
          return new InkWell(
            onTap: () {
              LogUtil.e("BannerModel: " + model.toString());
              NavigatorUtil.pushWeb(context,
                  title: model.title, url: model.url);
            },
            child: new CachedNetworkImage(
              fit: BoxFit.fill,
              imageUrl: model.imagePath,
              placeholder: (context, url) => new ProgressView(),
              errorWidget: (context, url, error) => new Icon(Icons.error),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget buildRepos(BuildContext context, List<ReposModel> list) {
    if (ObjectUtil.isEmpty(list)) {
      return new Container(height: 0.0);
    }
    List<Widget> _children = list.map((model) {
      return new ReposItem(
        model,
        isHome: true,
      );
    }).toList();
    List<Widget> children = new List();
    // 推荐项目条目
    children.add(new HeaderItem(
      leftIcon: Icons.book,
      titleId: Ids.recRepos, // 推荐项目
      onTap: () {
        NavigatorUtil.pushTabPage(context,
            labelId: Ids.titleReposTree, titleId: Ids.titleReposTree);
      },
    ));
    children.addAll(_children);
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }

  Widget buildWxArticle(BuildContext context, List<ReposModel> list) {
    if (ObjectUtil.isEmpty(list)) {
      return new Container(height: 0.0);
    }
    List<Widget> _children = list.map((model) {
      return new ArticleItem(
        model,
        isHome: true,
      );
    }).toList();
    List<Widget> children = new List();
    children.add(new HeaderItem(
      titleColor: Colors.green,
      leftIcon: Icons.library_books,
      titleId: Ids.recWxArticle,
      onTap: () {
        NavigatorUtil.pushTabPage(context,
            labelId: Ids.titleWxArticleTree, titleId: Ids.titleWxArticleTree);
      },
    ));
    children.addAll(_children);
    return new Column(
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }

  @override
  Widget build(BuildContext context) {
    LogUtil.e("HomePage build......");
    RefreshController _controller = new RefreshController();
    final MainBloc bloc = BlocProvider.of<MainBloc>(context);
    bloc.homeEventStream.listen((event) {
      if (labelId == event.labelId) {
        _controller.sendBack(false, event.status);
      }
    });

    if (isHomeInit) {
      LogUtil.e("HomePage init......");
      isHomeInit = false;
      Observable.just(1).delay(new Duration(milliseconds: 500)).listen((_) {
        // 请求刷新数据
        bloc.onRefresh(labelId: labelId);
        bloc.getHotRecItem();
        bloc.getVersion();
      });
    }

    return new StreamBuilder(
        stream: bloc.bannerStream,
        builder:
            (BuildContext context, AsyncSnapshot<List<BannerModel>> snapshot) {
          return new RefreshScaffold(
            labelId: labelId,
            loadStatus: Utils.getLoadStatus(snapshot.hasError, snapshot.data),
            controller: _controller,
            enablePullUp: false,
            onRefresh: ({bool isReload}) {
              return bloc.onRefresh(labelId: labelId);
            },
            child: new ListView(
              children: <Widget>[
                new StreamBuilder(
                    stream: bloc.recItemStream,
                    builder: (BuildContext context,
                        AsyncSnapshot<ComModel> snapshot) {
                      ComModel model = bloc.hotRecModel;
                      if (model == null) {
                        return new Container(
                          height: 0.0,
                        );
                      }
                      int status = Utils.getUpdateStatus(model.version);
                      return new HeaderItem(
                        titleColor: Colors.redAccent,
                        title: status == 0 ? model.content : model.title,
                        extra: status == 0 ? 'Go' : "",
                        onTap: () {
                          if (status == 0) {
                            NavigatorUtil.pushPage(
                                context, RecHotPage(title: model.content),
                                pageName: model.content);
                          } else {
                            NavigatorUtil.launchInBrowser(model.url,
                                title: model.title);
                          }
                        },
                      );
                    }),
                // 构建banner组件
                buildBanner(context, snapshot.data),
                // 构建推荐项目
                new StreamBuilder(
                    stream: bloc.recReposStream,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<ReposModel>> snapshot) {
                      return buildRepos(context, snapshot.data);
                    }),
                // 构建 推荐微信公众号
                new StreamBuilder(
                    stream: bloc.recWxArticleStream,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<ReposModel>> snapshot) {
                      return buildWxArticle(context, snapshot.data);
                    }),
              ],
            ),
          );
        });
  }
}

// SwiperIndicator 滑动指示组件
class NumberSwiperIndicator extends SwiperIndicator {
  @override
  Widget build(BuildContext context, int index, int itemCount) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.black45, borderRadius: BorderRadius.circular(20.0)),
      margin: EdgeInsets.only(top: 10.0, right: 5.0),
      padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
      child: Text("${++index}/$itemCount",
          style: TextStyle(color: Colors.white70, fontSize: 11.0)),
    );
  }
}
