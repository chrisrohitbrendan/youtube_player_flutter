import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MuteUmuteButton extends StatefulWidget {
  final Widget? bufferIndicator;

  const MuteUmuteButton({super.key, this.bufferIndicator});

  @override
  State<MuteUmuteButton> createState() => _MuteUmuteButtonState();
}

class _MuteUmuteButtonState extends State<MuteUmuteButton>
    with TickerProviderStateMixin {
  late YoutubePlayerController _controller;

  bool _mute = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final controller = YoutubePlayerController.of(context);
    if (controller != null) {
      _controller = controller;
      _controller.addListener(_controllerListener);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_controllerListener);
    super.dispose();
  }

  _controllerListener() {
    if (_controller.value.isMuted == _mute) return;
    setState(() {
      _mute = _controller.value.isMuted;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_controller.value.isReady) {
      return Visibility(
        visible: _controller.value.isControlsVisible,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(50.0),
            onTap: () {
              if (_mute) {
                _controller.unMute();
              } else {
                _controller.mute();
              }
            },
            child: _mute
                ? const Icon(
                    Icons.volume_off_rounded,
                    color: Colors.white,
                    size: 60.0,
                  )
                : const Icon(
                    Icons.volume_up_rounded,
                    color: Colors.white,
                    size: 60.0,
                  ),
          ),
        ),
      );
    }
    if (_controller.value.hasError) return const SizedBox();
    return widget.bufferIndicator ??
        Container(
          width: 70.0,
          height: 70.0,
          child: const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(Colors.white),
          ),
        );
  }
}
