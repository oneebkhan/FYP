import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class RowInfo extends StatelessWidget {
  final String location;
  final String imageURL;
  final String title;
  final double width;
  final Function func;

  const RowInfo({
    Key key,
    @required this.width,
    @required this.title,
    this.location,
    @required this.imageURL,
    @required this.func,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          func();
        },
        child: Ink(
          width: width,
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CachedNetworkImage(
                  imageUrl:
                      // the 4th image URL
                      imageURL,
                  imageBuilder: (context, imageProvider) => Container(
                    width: width / 9,
                    height: width / 9,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: imageProvider, fit: BoxFit.cover),
                    ),
                  ),
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
                SizedBox(
                  width: 15,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title.length > 24
                          ? title.substring(0, 23) + '...'
                          : title,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: width / 21.5,
                      ),
                    ),
                    location == null
                        ? Container()
                        : Text(
                            location.length > 31
                                ? location.substring(0, 30) + '...'
                                : location,
                            style: TextStyle(
                              fontSize: width / 29,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
