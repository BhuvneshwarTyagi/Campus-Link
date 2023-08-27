import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:video_player/video_player.dart';
import '../chat.dart';

class VideoTile extends StatefulWidget {
  const VideoTile(
      {super.key,
      required this.channel,
      required this.videoURL,
      required this.videoThumbnailURL});
  final String channel;
  final String videoURL;
  final String videoThumbnailURL;

  @override
  State<VideoTile> createState() => _VideoTileState();
}

class _VideoTileState extends State<VideoTile> {
  late VideoPlayerController videoPlayerController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  bool playing=false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            PageTransition(
                childCurrent: chat_page(channel: widget.channel),
                duration: const Duration(milliseconds: 400),
                child: VideoTile(channel: widget.channel, videoURL: widget.videoURL, videoThumbnailURL: widget.videoThumbnailURL,),
                type: PageTransitionType.bottomToTopJoined));
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: size.height * 0.008, vertical: size.height * 0.003),
        child: Container(
          width: double.maxFinite,
          height: size.height * 0.28,
          decoration: playing ?
          BoxDecoration(
              color: Colors.black,
              borderRadius: const BorderRadius.all(Radius.circular(12)),
              border: Border.all(color: Colors.black, width: 2))
              :
          BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(widget.videoThumbnailURL),
                  fit: BoxFit.fill),
              color: Colors.black,
              borderRadius: const BorderRadius.all(Radius.circular(12)),
              border: Border.all(color: Colors.black, width: 2)),
          child: playing
              ?
          Center(
            child: Container(
              color: Colors.black,
              height: double.maxFinite,
              width: double.maxFinite,
              child: videoPlayerController.value.isInitialized
                  ?
              Stack(
                alignment: Alignment.center,
                children: [
                  AspectRatio(
                    aspectRatio: videoPlayerController.value.aspectRatio,
                    child: VideoPlayer(videoPlayerController),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        if(videoPlayerController.value.duration == videoPlayerController.value.position){
                          videoPlayerController.initialize();
                        }
                        videoPlayerController.value.isPlaying
                            ? videoPlayerController.pause()
                            : videoPlayerController.play();
                      });
                    },
                    icon: CircleAvatar(
                      backgroundColor: Colors.black54,
                      child: Icon(
                        videoPlayerController.value.isPlaying ? Icons.pause : Icons.play_arrow,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              )
                  :
              const Center(child: CircularProgressIndicator()),
            ),
          )
              :
          IconButton(
            onPressed: () {
              setState(() {
                videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(widget.videoURL));
                videoPlayerController.initialize().then((value) {
                  setState(() {
                    print("Initialized");
                  });
                });
                videoPlayerController.setLooping(true);
                playing=true;
                if(videoPlayerController.value.duration == videoPlayerController.value.position){
                  videoPlayerController.initialize();
                }
                videoPlayerController.value.isPlaying
                    ? videoPlayerController.pause()
                    : videoPlayerController.play();
              });
            },
            icon: CircleAvatar(
              backgroundColor: Colors.black54,
              child: Icon(
                videoPlayerController.value.isPlaying ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
