import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

Widget networkImage(
  String image, {
  double? height = 50,
  double? width,
}) =>
    SizedBox(
      height: height,
      width: width,
      child: CachedNetworkImage(
        imageUrl: image,
        imageBuilder: (context, imageProvider) => Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.fill,
            ),
          ),
        ),
        placeholder: (context, url) => Container(
          alignment: Alignment.center,
          child:
              const CircularProgressIndicator(), // you can add pre loader iamge as well to show loading.
        ), //show progress  while loading image
        errorWidget: (context, url, error) =>
            Image.asset("assets/images/icon-512x512.png"),
        //show no iamge availalbe image on error laoding
      ),
    );
