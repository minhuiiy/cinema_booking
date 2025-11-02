/*
 * @ Author: Chung Nguyen Thanh <chunhthanhde.dev@gmail.com>
 * @ Created: 2024-12-21 21:28:06
 * @ Message: 🎯 Happy coding and Have a nice day! 🌤️
 */

import 'package:cinema_booking/common/widgets/button/basic_back_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart' as ypf;
import 'package:youtube_player_iframe/youtube_player_iframe.dart' as yti;

class WidgetVideoPlayer extends StatefulWidget {
  final String videoUrl;

  const WidgetVideoPlayer({super.key, required this.videoUrl});

  @override
  State<WidgetVideoPlayer> createState() => _WidgetVideoPlayerState();
}

class _WidgetVideoPlayerState extends State<WidgetVideoPlayer> {
  ypf.YoutubePlayerController? _mobileController;
  yti.YoutubePlayerController? _webController;

  bool _isPlayerReady = false;
  String? _videoId;

  @override
  void initState() {
    super.initState();
    _videoId = _extractVideoId(widget.videoUrl);

    if (kIsWeb) {
      if (_videoId != null && _videoId!.isNotEmpty) {
        _webController = yti.YoutubePlayerController.fromVideoId(
          videoId: _videoId!,
          autoPlay: false,
          params: const yti.YoutubePlayerParams(
            showControls: true,
            showFullscreenButton: true,
          ),
        );
      }
    } else {
      _mobileController = ypf.YoutubePlayerController(
        initialVideoId: _videoId ?? '',
        flags: const ypf.YoutubePlayerFlags(
          mute: false,
          autoPlay: false,
          disableDragSeek: false,
          loop: false,
          isLive: false,
          forceHD: false,
          enableCaption: true,
        ),
      )..addListener(_listener);
    }
  }

  void _listener() {
    if (_isPlayerReady && mounted && !(_mobileController?.value.isFullScreen ?? false)) {
      // no-op
    }
  }

  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    if (!kIsWeb) {
      _mobileController?.pause();
    }
    super.deactivate();
  }

  @override
  void dispose() {
    if (kIsWeb) {
      _webController?.close();
    } else {
      _mobileController?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget player;

    if (kIsWeb) {
      player = _webController != null
          ? yti.YoutubePlayer(
              controller: _webController!,
              aspectRatio: 16 / 9,
            )
          : const SizedBox.shrink();
    } else {
      player = ypf.YoutubePlayer(
        controller: _mobileController!,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.blueAccent,
        onReady: () {
          _isPlayerReady = true;
        },
      );
    }

    return Stack(
      children: <Widget>[
        player,
        BasicBackButton(padding: const EdgeInsets.only(left: 20, top: 20)),
      ],
    );
  }

  String? _extractVideoId(String url) {
    try {
      final uri = Uri.parse(url);
      if (uri.host.contains('youtu.be')) {
        return uri.pathSegments.isNotEmpty ? uri.pathSegments.last : null;
      }
      final vParam = uri.queryParameters['v'];
      if (vParam != null && vParam.isNotEmpty) return vParam;
      final segments = uri.pathSegments;
      final embedIndex = segments.indexOf('embed');
      if (embedIndex != -1 && segments.length > embedIndex + 1) {
        return segments[embedIndex + 1];
      }
      return segments.isNotEmpty ? segments.last : null;
    } catch (_) {
      return null;
    }
  }
}
