import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:flutter/material.dart';
import 'package:poetry_app/components/poem_card.dart';
import 'package:poetry_app/models/poem/poem.dart';
import 'package:poetry_app/providers/favorite_provider.dart';
import 'package:poetry_app/providers/poem_provider.dart';

import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with AutomaticKeepAliveClientMixin {
  final _keepAlive = true;

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

  @override
  bool get wantKeepAlive => _keepAlive;
}
