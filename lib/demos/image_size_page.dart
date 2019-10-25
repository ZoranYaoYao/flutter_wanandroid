import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/res/styles.dart';

class ImageSizePage extends StatefulWidget {
  final String title;

  ImageSizePage(this.title);

  @override
  State<StatefulWidget> createState() {
    return new _ImageSizePageState();
  }
}

class _ImageSizePageState extends State<ImageSizePage> {
  String cacheImgInfo1 = "[CachedNetworkImage] loading...";
  String netImgInfo1 = "[网络图片1] loading...";
  String localImgInfo1 = "[本地图片 ali_connors] loading...";
  String netImgInfoE = "[网络图片E] loading...";
  String netUrl1 =
      "https://upload-images.jianshu.io/upload_images/13222938-74a4dc4115d76790.png";
  String netUrl2 =
      "https://upload-images.jianshu.io/upload_images/13222938-74a4dc4115d76790.png";
  String netUrlE = "https://xxx.png";
  String localImgUrl = "assets/images/3.0x/ali_connors.png";

  @override
  void initState() {
    super.initState();
    _loadCachedNetworkImage();
    _loadNetUrl1();
    _loadLocalUrl1();
    _initAsync2();
  }

  void _loadCachedNetworkImage() async {
    Image image = new Image(image: new CachedNetworkImageProvider(netUrl2));
    // 1.直接通过img.image.addListener() 去监听图片的回调对象Rect
    Rect rect = await WidgetUtil.getImageWH(image: image);
    cacheImgInfo1 =
        "[CachedNetworkImage] width: ${rect.width}, height: ${rect.height}";
    setState(() {});

//    Image imageAsset = new Image.asset("");
//    Image imageFile = new Image.file(File("path"));
//    Image imageNetwork = new Image.network("url");
//    Image imageMemory = new Image.memory(null);
  }

  void _loadNetUrl1() async {
    // 2.通过封装Image.network(url) 方法 异步获取返回对象Rect
    Rect rect = await WidgetUtil.getImageWH(url: netUrl1);
    netImgInfo1 = "[网络图片1] width: ${rect.width}, height: ${rect.height}";
    setState(() {});
  }

  void _loadLocalUrl1() async {
    // 3.通过封装Image.asset方法，异步获取返回对象Rect
    Rect locImg1 = await WidgetUtil.getImageWH(localUrl: localImgUrl);
    localImgInfo1 =
        "[本地图片 ali_connors] width: ${locImg1.width}, height: ${locImg1.height}";
    setState(() {});
  }

  void _initAsync2() {
    // 通过Future.catchError() 抓取图片异常
    WidgetUtil.getImageWHE(url: netUrlE).then((Rect rect) {
      netImgInfoE = "[网络图片2] width: ${rect.width}, height: ${rect.height}";
      setState(() {});
    }).catchError((error) {
      netImgInfoE = "[网络图片2] error" + error.toString();
      setState(() {});
    });
  }

  Widget _buildItem(String info, {double height = 50}) {
    return new Container(
      alignment: Alignment.center,
      height: height,
      child: new Text(
        "$info",
        style: TextStyles.listContent,
      ),
      decoration: Decorations.bottom,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
        centerTitle: true,
      ),
      body: new ListView(
        // zqs_nice: ListView直接赋值有多少个children
        children: <Widget>[
          _buildItem(cacheImgInfo1),
          _buildItem(netImgInfo1),
          _buildItem(localImgInfo1),
          _buildItem(netImgInfoE, height: 100),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
