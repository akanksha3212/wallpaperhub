import 'dart:io';
import 'dart:ui';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:flutter/services.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wallpaper_manager/wallpaper_manager.dart';
import 'package:image_saver/image_saver.dart';

import 'package:wallpaper/models/photos_model.dart';
class ImageView extends StatefulWidget {
  final String imgPath;

  ImageView({@required this.imgPath});

  @override
  _ImageViewState createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Hero(
            tag: widget.imgPath,
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: kIsWeb
                  ? Image.network(widget.imgPath, fit: BoxFit.cover)
                  : CachedNetworkImage(
                      imageUrl: widget.imgPath,
                      placeholder: (context, url) => Container(
                        color: Color(0xfff5f8fd),
                      ),
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                InkWell(
                    onTap: () {
                      if (kIsWeb) {
                        _launchURL(widget.imgPath);

                        //js.context.callMethod('downloadUrl',[widget.imgPath]);
                        //response = await dio.download(widget.imgPath, "./xx.html");
                      } else {
                       _save();
                        Navigator.pop(context);
                      }
                    },
                    child: Stack(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width / 2,
                          height: 50,

                          decoration: BoxDecoration(
                            color: Color(0xff1C1B1B).withOpacity(0.8),
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                        Container(
                            width: MediaQuery.of(context).size.width / 2,
                            height: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.white24, width: 1),
                                borderRadius: BorderRadius.circular(40),
                                gradient: LinearGradient(
                                    colors: [
                                      Color(0x36FFFFFF),
                                      Color(0x0FFFFFFF)
                                    ],
                                    begin: FractionalOffset.topLeft,
                                    end: FractionalOffset.bottomRight)),
                            child:InkWell(
                              onTap: (){
                              Fluttertoast.showToast(
                                  msg: "Image saved in gallery",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.transparent,
                                  textColor: Colors.white,
                                  fontSize: 20.0);},
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Text(
                                  "Save Image in Gallery",
                                  style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  kIsWeb
                                      ? "Image will open in new tab to download"
                                      : "(Image will be saved in gallery)",
                                  style: TextStyle(
                                      fontSize: 7,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white70),
                                ),
                                SizedBox(
                                  height: 1,
                                ),
                              ],
                            )),
                        ) ],
                    )),
                SizedBox(
                  height: 16,
                ),
                InkWell(
                    onTap: () {



                    },
                    child: Stack(children: <Widget>[
                      FlatButton(
                    color: Color(0xff1C1B1B).withOpacity(0.8),
                          height: 50,
                          minWidth: MediaQuery.of(context).size.width/2,
                         padding: EdgeInsets.symmetric(),
                         shape:RoundedRectangleBorder(borderRadius:new BorderRadius.all(new Radius.circular(40.0),) , side: new BorderSide(color: Colors.white24)),
                          child: Container(
                              width: MediaQuery.of(context).size.width / 2,
                              height: 50,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(

                                  border:
                                  Border.all(color: Colors.white24, width: 1),
                                  borderRadius: BorderRadius.circular(40),
                                  gradient: LinearGradient(
                                      colors: [
                                        Color(0x36FFFFFF),
                                        Color(0x0FFFFFFF)
                                      ],
                                      begin: FractionalOffset.topLeft,
                                      end: FractionalOffset.bottomRight)

                          ),
                          child:Text(
                            "Set Wallpaper",
                            style: TextStyle(
                                color: Colors.white70,
                                fontSize: 10,
                                fontWeight: FontWeight.w500),
                          )
                            ,),

                          onPressed: () {

                            showDialog(
                                context: context,barrierDismissible: true,
                                barrierColor: Colors.white.withOpacity(.5),
                                builder: (BuildContext dialogContext) {
                                  return SimpleDialog(
                                    titlePadding:
                                        EdgeInsets.fromLTRB(24, 32, 43, 54),
                                    backgroundColor: Colors.white,
                                    children: [
                                      FlatButton(
                                          child: Text("Set for homescreen"),
                                          onPressed: () {
                                            int location = WallpaperManager
                                                .HOME_SCREEN; // or location = WallpaperManager.LOCK_SCREEN;

                                            try {
                                              _setWallpaper(location);
                                              Fluttertoast.showToast(
                                                  msg: "Wallpaper updated successfully",
                                                  toastLength: Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.CENTER,
                                                  timeInSecForIosWeb: 2,
                                                  backgroundColor: Colors.transparent,
                                                  textColor: Colors.white,
                                                  fontSize: 20.0,);

                                            } on PlatformException {
                                              String resultw =
                                                  'Failed to get wallpaper.';



                                            }    Navigator.pop(context);// or location = WallpaperManager.LOCK_SCREEN;
                                          }),
                                      FlatButton(
                                          child: Text("Set for lockscreen"),
                                          onPressed: () {
                                            int location = WallpaperManager
                                                .LOCK_SCREEN;
                                            // or location = WallpaperManager.LOCK_SCR

                                            try {
                                              _setWallpaper(location);
                                              Fluttertoast.showToast(
                                                  msg: "Wallpaper updated successfully",
                                                  toastLength: Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.CENTER,
                                                  timeInSecForIosWeb: 2,
backgroundColor: Colors.transparent,
                                                  textColor: Colors.white,
                                                  fontSize: 20.0);

                                            } on PlatformException {

print("fail");

                                            }
                                           Navigator.pop(context);// or location = WallpaperManager.LOCK_SCREEN;
                                          }
                                          ),



                                        FlatButton(
                                            child: Text("Set for both"),
                                            onPressed: () {

                                  int location = WallpaperManager.BOTH_SCREENS; // or location = WallpaperManager.LOCK_SCREEN;
// var resultw;
                                  try {
                                    _setWallpaper
                                      (location);





                                    Fluttertoast.showToast(
                                        msg: "Wallpaper updated successfully",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 5,
                                        backgroundColor: Colors.transparent,
                                        textColor: Colors.white,
                                        fontSize: 20.0);

                                  } on PlatformException {

                                    print("fail");
                 }Navigator.pop(context);
                                            }

                                            ),

                                    ],

                                  );
                                });
                          })
                    ])),
                SizedBox(
                  height: 16,
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                SizedBox(
                  height: 50,
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  _save() async {
    await _askPermission();

    var response = await Dio().get(widget.imgPath,
        options: Options(responseType: ResponseType.bytes));

     await ImageSaver.toFile(fileData: response.data);

    await ImageDownloader.downloadImage(widget.imgPath,
        destination: AndroidDestinationType.directoryPictures);


   Navigator.pop(context);

  }

  _askPermission() async {
    try {
      if (Platform.isIOS) {
        await PermissionHandler().requestPermissions([PermissionGroup.photos]);
      }
      if (Platform.isAndroid && TargetPlatform.android == 28) {
        //await PermissionHandler()
          //flutter clean  .checkPermissionStatus(PermissionGroup.accessMediaLocation);
      } else {

      }
    } catch (Exception) {

    }
  }

  _setWallpaper(location) async {

    await _askPermission();





  String imageId = await ImageDownloader.downloadImage(widget.imgPath,
      destination: AndroidDestinationType.directoryPictures);
  var path = await ImageDownloader.findPath(imageId);
try {
  await WallpaperManager.setWallpaperFromFile(path,location);
}catch(onException){
  print("ggggggggg");
}


  }
}
