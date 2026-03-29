import 'package:flutter/material.dart';

class AudioControls extends StatelessWidget {
  const AudioControls({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.shuffle_rounded)),
        IconButton(
            onPressed: () {}, icon: const Icon(Icons.skip_previous_rounded)),
        const SizedBox(width: 4),
        CircleAvatar(
          radius: 28,
          child: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.play_arrow_rounded, size: 30),
          ),
        ),
        const SizedBox(width: 4),
        IconButton(onPressed: () {}, icon: const Icon(Icons.skip_next_rounded)),
        IconButton(onPressed: () {}, icon: const Icon(Icons.repeat_rounded)),
      ],
    );
  }
}
