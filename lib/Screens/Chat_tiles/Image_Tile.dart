import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../Image_viewer.dart';
import '../chat.dart';

class ImageTile extends StatelessWidget {
  const ImageTile({super.key, required this.channel, required this.imageURL});
  final String channel;
  final String imageURL;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            PageTransition(
                childCurrent: chat_page(channel: channel),
                duration: const Duration(milliseconds: 400),
                child: Image_viewer(url: imageURL),
                type: PageTransitionType.bottomToTopJoined));
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: size.height * 0.008, vertical: size.height * 0.003),
        child: Container(
          width: double.maxFinite,
          decoration: BoxDecoration(
              // image: DecorationImage(
              //     image: NetworkImage(imageURL), fit: BoxFit.fill),
              color: Colors.black.withOpacity(0.5),
              borderRadius: const BorderRadius.all(Radius.circular(12)),
              border: Border.all(color: Colors.black, width: 2),
          ),
          child: Image.network(
            imageURL,
            fit: BoxFit.contain,
            cacheHeight: int.parse("${double.maxFinite}")
          ),
        ),
      ),
    );
  }
}
