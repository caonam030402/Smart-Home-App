import 'package:flutter/material.dart';

class LightAdjustmentBar extends StatefulWidget {
  final double lightness;
  final double width;
  final double thumbSize;
  final double hue;

  const LightAdjustmentBar({
    Key? key,
    required this.lightness,
    required this.width,
    required this.thumbSize,
    required this.hue,
  }) : super(key: key);

  @override
  _LightAdjustmentBarState createState() => _LightAdjustmentBarState();
}

class _LightAdjustmentBarState extends State<LightAdjustmentBar> {
  late double _lightness;

  @override
  void initState() {
    super.initState();
    _lightness = widget.lightness
        .clamp(0.0, 1.0); // Ensure lightness is within valid range
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.thumbSize,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: <Widget>[
          Container(
            width: double.infinity,
            height: 12,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(6)),
              gradient: LinearGradient(
                stops: [0, 0.4, 1],
                colors: [
                  HSLColor.fromAHSL(1, widget.hue, 1, 0).toColor(),
                  HSLColor.fromAHSL(1, widget.hue, 1, 0.5).toColor(),
                  HSLColor.fromAHSL(1, widget.hue, 1, 0.9).toColor(),
                ],
              ),
            ),
          ),
          Positioned(
            left: _lightness * (widget.width - widget.thumbSize),
            child: Slider(
              min: 0.0,
              max: 1.0,
              value: _lightness,
              onChanged: (newValue) {
                setState(() {
                  _lightness = newValue;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
