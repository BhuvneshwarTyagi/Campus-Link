import 'package:campus_link_teachers/Screens/Chat_tiles/Video_Tile.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({super.key, required this.channel, this.videoURL, this.videoThumbnailURL});
  final String channel;
  final videoURL;
  final videoThumbnailURL;
  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController videoPlayerController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(widget.videoURL));
    videoPlayerController.initialize().then((value) {
      if(mounted){
        setState(() {
          print("Initialized");
        });
      }
    });
  }
  bool playing=false;
  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return Container(
      height: size.height,
      color: Colors.black54,
      child: Scaffold(
        backgroundColor: Colors.black,
        floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black54,
          onPressed: (){
            Navigator.pop(context);
            },
          child: const Icon(Icons.clear,color: Colors.white,),
        ),
        body: Container(
          height: size.height*1,
          alignment: Alignment.center,
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
          videoPlayerController.value.isInitialized
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
          const Center(child: CircularProgressIndicator())
              :
          IconButton(
            onPressed: () {
              setState(() {
                playing=true;
                videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(widget.videoURL));
                videoPlayerController.initialize().then((value) {
                  setState(() {
                    print("Initialized");
                  });
                });
                videoPlayerController.setLooping(true);
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
