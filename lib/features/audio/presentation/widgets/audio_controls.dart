import 'package:flutter/material.dart';

class AudioControls extends StatelessWidget {
  const AudioControls({
    super.key,
    required this.isPlaying,
    this.isShuffleEnabled = false,
    this.isRepeatEnabled = false,
    this.onPlayPause,
    this.onNext,
    this.onPrevious,
    this.onShuffle,
    this.onRepeat,
  });

  final bool isPlaying;
  final bool isShuffleEnabled;
  final bool isRepeatEnabled;
  final VoidCallback? onPlayPause;
  final VoidCallback? onNext;
  final VoidCallback? onPrevious;
  final VoidCallback? onShuffle;
  final VoidCallback? onRepeat;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: onShuffle,
          icon: Icon(
            Icons.shuffle_rounded,
            color:
                isShuffleEnabled ? Theme.of(context).colorScheme.primary : null,
          ),
        ),
        IconButton(
          onPressed: onPrevious,
          icon: const Icon(Icons.skip_previous_rounded),
        ),
        const SizedBox(width: 4),
        CircleAvatar(
          radius: 28,
          child: IconButton(
            onPressed: onPlayPause,
            icon: Icon(
              isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
              size: 30,
            ),
          ),
        ),
        const SizedBox(width: 4),
        IconButton(
          onPressed: onNext,
          icon: const Icon(Icons.skip_next_rounded),
        ),
        IconButton(
          onPressed: onRepeat,
          icon: Icon(
            Icons.repeat_rounded,
            color:
                isRepeatEnabled ? Theme.of(context).colorScheme.primary : null,
          ),
        ),
      ],
    );
  }
}
