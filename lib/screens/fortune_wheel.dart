import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fortune_wheel/components/fortune.dart';
import 'package:fortune_wheel/screens/board_view.dart';

class FortuneWheel extends StatefulWidget {
  const FortuneWheel({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _FortuneWheelState();
  }
}

class _FortuneWheelState extends State<FortuneWheel>
    with SingleTickerProviderStateMixin {
  double _angle = 0;
  double _current = 0;
  AnimationController? _ctrl;
  Animation? _ani;
  final List<Fortune> _items = [
    Fortune("apple", const Color(0xffB087FF)),
    Fortune("raspberry", const Color(0xff41237A)),
    Fortune("grapes", const Color(0xffB087FF)),
    Fortune("fruit", const Color(0xff41237A)),
    Fortune("milk", const Color(0xffB087FF)),
    Fortune("salad", const Color(0xff41237A)),
    Fortune("cheese", const Color(0xffB087FF)),
    Fortune("carrot", const Color(0xff41237A)),
  ];

  @override
  void initState() {
    super.initState();
    var _duration = const Duration(milliseconds: 5000);
    _ctrl = AnimationController(vsync: this, duration: _duration);
    _ani =
        CurvedAnimation(parent: _ctrl!, curve: Curves.fastLinearToSlowEaseIn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xff1C0649), Color(0xff282828)],
          ),
        ),
        child: AnimatedBuilder(
            animation: _ani!,
            builder: (context, child) {
              final _value = _ani!.value;
              final _angle = _value * this._angle;
              return Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  BoardView(items: _items, current: _current, angle: _angle),
                  _buildGo(),
                  _buildResult(_value),
                ],
              );
            }),
      ),
    );
  }

  _buildGo() {
    return InkWell(
      customBorder: const CircleBorder(),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xff1C0649), Color(0xff282828)],
          ),
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        height: 72,
        width: 72,
        child: const Text(
          "GO",
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      onTap: _animation,
    );
  }

  _animation() {
    if (!_ctrl!.isAnimating) {
      var _random = Random().nextDouble();
      _angle = 20 + Random().nextInt(5) + _random;
      _ctrl!.forward(from: 0.0).then((_) {
        _current = (_current + _random);
        _current = _current - _current ~/ 1;
        _ctrl!.reset();
      });
    }
  }

  int _calIndex(value) {
    var _base = (2 * pi / _items.length / 2) / (2 * pi);
    return (((_base + value) % 1) * _items.length).floor();
  }

  _buildResult(_value) {
    var _index = _calIndex(_value * _angle + _current);
    String _asset = _items[_index].asset;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Image.asset(_asset, height: 80, width: 80),
      ),
    );
  }
}
