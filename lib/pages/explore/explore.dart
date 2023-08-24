import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:flutter/material.dart';
import 'package:PoeticSwipe/pages/explore/poem_card.dart';
import 'package:PoeticSwipe/models/poem/poem.dart';
import 'package:PoeticSwipe/providers/poem_provider.dart';

import 'package:provider/provider.dart';

class Explore extends StatefulWidget {
  const Explore({super.key});

  @override
  State<Explore> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Consumer<PoemProvider>(
      builder: (context, provider, child) {
        return provider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : Center(
                child: FractionallySizedBox(
                  heightFactor: 0.8,
                  widthFactor: 0.95,
                  child: AppinioSwiper(
                    cardsCount: provider.poems.length,
                    onSwipe: (index, direction) {
                      provider.markRead(index - 1);
                    },
                    onEnd: provider.loadPoemBatch,
                    cardsBuilder: (_, int index) {
                      Poem? poem = provider.getPoem(index);
                      return PoemCard(
                          poem: poem, color: provider.getColor(index));
                    },
                  ),
                ),
              );
      },
    );
  }

  final _keepAlive = true;
  @override
  bool get wantKeepAlive => _keepAlive;
}
