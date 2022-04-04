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
    Fortune("apple", Colors.accents[0]),
    Fortune("raspberry", Colors.accents[2]),
    Fortune("grapes", Colors.accents[4]),
    Fortune("fruit", Colors.accents[6]),
    Fortune("milk", Colors.accents[8]),
    Fortune("salad", Colors.accents[10]),
    Fortune("cheese", Colors.accents[12]),
    Fortune("carrot", Colors.accents[14]),
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
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.green, Colors.blue.withOpacity(0.2)],
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
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        child: Container(
          alignment: Alignment.center,
          height: 72,
          width: 72,
          child: const Text(
            "GO",
            style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
          ),
        ),
        onTap: _animation,
      ),
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
