import 'package:flutter/material.dart';

class SliverAppbarWithFixibleSpaceBar extends StatefulWidget {
  @override
  State<SliverAppbarWithFixibleSpaceBar> createState() =>
      _SliverAppbarWithFixibleSpaceBarState();
}

const double kMaxExpandHeight = 200.0;

class _SliverAppbarWithFixibleSpaceBarState
    extends State<SliverAppbarWithFixibleSpaceBar>
    with SingleTickerProviderStateMixin {
  double _percentageExpanded = 0;
  late AnimationController _animatedContainer;

  late ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();
    _animatedContainer = AnimationController(
        vsync: this,
        duration: const Duration(
          milliseconds: 600,
        ))
      ..addStatusListener((status) {
        print('animation status $status');
      });

    _scrollController.addListener(() {
      _percentageExpanded =
          _scrollController.offset / (kMaxExpandHeight - kToolbarHeight);
      if (_percentageExpanded > 1) {
        _percentageExpanded = 1;
      }
      _animatedContainer.value = _percentageExpanded;
      //print('_percentageExpanded $_percentageExpanded');
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverAppBar(
              primary: false,
              collapsedHeight: 100,
              expandedHeight: _calculatorExpand(),
              floating: false,
              pinned: true,
              centerTitle: false,
              title: SafeArea(
                child: AnimatedBuilder(
                  animation: _animatedContainer,
                  builder: (context, child) {
                    return Opacity(
                      opacity: 1 - _animatedContainer.value,
                      child: const Text('Appbar text'),
                    );
                  },
                ),
              ),
              actions: const [
                SafeArea(
                  child: CircleAvatar(
                    radius: 20,
                    child: Text('H'),
                  ),
                )
              ],
              flexibleSpace: LayoutBuilder(
                builder: (context, constants) {
                  return FlexibleSpaceBar(
                    stretchModes: const [
                      StretchMode.blurBackground,
                      StretchMode.fadeTitle,
                    ],
                    expandedTitleScale: 1.2,
                    title: _drawTitleFlexible(),
                    background: _drawBackGroundFlexible(constants),
                  );
                },
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Column(
                    children: [
                      Container(
                        height: 1000.0,
                        color: Colors.white,
                      ),
                      Container(
                        height: 100.0,
                        color: Colors.red,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _calculatorExpand() {
    return kMaxExpandHeight;
  }

  /// create a background with the image rounded bottom
  _drawBackGroundFlexible(BoxConstraints constants) {
    return Stack(
      children: [
        SizedBox(
          height: constants.maxHeight * (2 / 3),
          width: constants.maxWidth,
          child: Image.network(
            "https://picsum.photos/250?image=9",
            fit: BoxFit.cover,
          ),
        ),
      ],
    );
  }

  /// Create title of sliver Appbar
  _drawTitleFlexible() {
    return const SliverAppbarTitleCollapse();
  }
}

class SliverAppbarTitleCollapse extends StatelessWidget {
  const SliverAppbarTitleCollapse({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _expandCard();
  }

  Widget _expandCard() => LayoutBuilder(
        builder: (context, constants) {
          return Container(
            height: kMaxExpandHeight,
            color: Colors.red.withOpacity(0.5),
            child: Stack(
              children: [
                Container(
                  constraints: BoxConstraints.tightFor(
                    width: constants.maxWidth
                  ),
                  child: Container(
                    color: Colors.pink.withOpacity(0.1),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SafeArea(
                      bottom: false,
                      child: Container(
                        height: 56,
                        color: Colors.amber,
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        },
      );
}
