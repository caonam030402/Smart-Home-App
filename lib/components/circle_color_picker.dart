import 'dart:async';
import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:smart_home/styles/app_colors.dart';
import 'package:smart_home/styles/app_styles.dart';
import 'package:smart_home/styles/app_text.dart';

typedef ColorCodeBuilder = Widget Function(BuildContext context, Color color);

class CircleColorPickerController extends ChangeNotifier {
  CircleColorPickerController({
    Color initialColor = const Color.fromARGB(255, 255, 0, 0),
  }) : _color = initialColor;

  Color _color;
  Color get color => _color;
  set color(Color color) {
    _color = color;
    notifyListeners();
  }
}

class CircleColorPicker extends StatefulWidget {
  const CircleColorPicker({
    Key? key,
    this.onChanged,
    this.onEnded,
    this.size = const Size(240, 240),
    this.strokeWidth = 15,
    this.thumbSize = 32,
    this.controller,
    this.textStyle = const TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
    this.colorCodeBuilder,
  }) : super(key: key);

  /// Called during a drag when the user is selecting a color.
  ///
  /// This callback called with latest color that user selected.
  final ValueChanged<Color>? onChanged;

  /// Called when drag ended.
  ///
  /// This callback called with latest color that user selected.
  final ValueChanged<Color>? onEnded;

  /// An object to controll picker color dynamically.
  ///
  /// Provide initialColor if needed.
  final CircleColorPickerController? controller;

  /// The size of widget.
  /// Draggable area is thumb widget is included to the size,
  /// so circle is smaller than the size.
  ///
  /// Default value is 280 x 280.
  final Size size;

  /// The width of circle border.
  ///
  /// Default value is 2.
  final double strokeWidth;

  /// The size of thumb for circle picker.
  ///
  /// Default value is 32.
  final double thumbSize;

  /// Text style config
  ///
  /// Default value is Black
  final TextStyle textStyle;

  /// Widget builder that show color code section.
  /// This functions is called every time color changed.
  ///
  /// Default is Text widget that shows rgb strings;
  final ColorCodeBuilder? colorCodeBuilder;

  Color get initialColor =>
      controller?.color ?? const Color.fromARGB(255, 255, 0, 0);

  double get initialLightness => HSLColor.fromColor(initialColor).lightness;

  double get initialHue => HSLColor.fromColor(initialColor).hue;

  @override
  _CircleColorPickerState createState() => _CircleColorPickerState();
}

class _CircleColorPickerState extends State<CircleColorPicker>
    with TickerProviderStateMixin {
  late AnimationController _lightnessController;
  late AnimationController _hueController;

  Color get _color {
    return HSLColor.fromAHSL(
      1,
      _hueController.value,
      1,
      _lightnessController.value,
    ).toColor();
  }

  @override
  Widget build(BuildContext context) {
    final databaseReference = FirebaseDatabase.instance.ref("");
    return SizedBox(
      width:
          MediaQuery.sizeOf(context).width - AppStyles.paddingBothSidesPage * 2,
      child: Stack(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Center(
                    child: _HuePicker(
                      hue: _hueController.value,
                      size: widget.size,
                      strokeWidth: widget.strokeWidth,
                      thumbSize: widget.thumbSize,
                      onEnded: _onEnded,
                      onChanged: (hue) {
                        _hueController.value = hue;
                      },
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    left: 0,
                    top: 0,
                    child: AnimatedBuilder(
                      animation: _hueController,
                      builder: (context, child) {
                        return AnimatedBuilder(
                          animation: _lightnessController,
                          builder: (context, _) {
                            return Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  const SizedBox(height: 16),
                                  Container(
                                    width: 150,
                                    height: 150,
                                    decoration: BoxDecoration(
                                      color: _color,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                        child: GestureDetector(
                                      onTap: () {
                                        databaseReference.update(
                                          {
                                            "light_control/colors/": {
                                              "blue":
                                                  widget.controller?.color.blue,
                                              "red":
                                                  widget.controller?.color.red,
                                              "green":
                                                  widget.controller?.color.green
                                            }
                                          },
                                        );
                                      },
                                      child: Container(
                                        width: 80,
                                        decoration: BoxDecoration(
                                            color: AppColors.white,
                                            borderRadius:
                                                BorderRadius.circular(200)),
                                        height: 30,
                                        child:
                                            const Center(child: Text('Update')),
                                      ),
                                    )),
                                  ),
                                  const SizedBox(height: 16),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Color intensity',
                style: AppText.large,
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  _LightnessSlider(
                    width: MediaQuery.sizeOf(context).width -
                        AppStyles.paddingBothSidesPage * 2,
                    thumbSize: 30,
                    hue: _hueController.value,
                    lightness: _lightnessController.value,
                    onEnded: _onEnded,
                    onChanged: (lightness) {
                      _lightnessController.value = lightness;
                    },
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _hueController = AnimationController(
      vsync: this,
      value: widget.initialHue,
      lowerBound: 0,
      upperBound: 360,
    )..addListener(_onColorChanged);
    _lightnessController = AnimationController(
      vsync: this,
      value: widget.initialLightness,
      lowerBound: 0,
      upperBound: 1,
    )..addListener(_onColorChanged);
    widget.controller?.addListener(_setColor);
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_setColor);
    super.dispose();
  }

  void _onColorChanged() {
    widget.onChanged?.call(_color);
    widget.controller?.color = _color;
  }

  void _onEnded() {
    widget.onEnded?.call(_color);
  }

  void _setColor() {
    if (widget.controller != null && widget.controller!.color != _color) {
      final hslColor = HSLColor.fromColor(widget.controller!.color);
      _hueController.value = hslColor.hue;
      _lightnessController.value = hslColor.lightness;
    }
  }
}

class _LightnessSlider extends StatefulWidget {
  const _LightnessSlider({
    Key? key,
    required this.hue,
    required this.lightness,
    required this.width,
    required this.onChanged,
    required this.onEnded,
    required this.thumbSize,
  }) : super(key: key);

  final double hue;

  final double lightness;

  final double width;

  final ValueChanged<double> onChanged;

  final VoidCallback onEnded;

  final double thumbSize;

  @override
  _LightnessSliderState createState() => _LightnessSliderState();
}

class _LightnessSliderState extends State<_LightnessSlider>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  Timer? _cancelTimer;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanDown: _onDown,
      onPanCancel: _onCancel,
      onHorizontalDragStart: _onStart,
      onHorizontalDragUpdate: _onUpdate,
      onHorizontalDragEnd: _onEnd,
      onVerticalDragStart: _onStart,
      onVerticalDragUpdate: _onUpdate,
      onVerticalDragEnd: _onEnd,
      child: SizedBox(
        width: widget.width,
        height: widget.thumbSize,
        child: Stack(
          alignment: Alignment.centerLeft,
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 5.5,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(6)),
                gradient: LinearGradient(
                  stops: const [0, 0.4, 1],
                  colors: [
                    HSLColor.fromAHSL(1, widget.hue, 1, 0).toColor(),
                    HSLColor.fromAHSL(1, widget.hue, 1, 0.5).toColor(),
                    HSLColor.fromAHSL(1, widget.hue, 1, 0.9).toColor(),
                  ],
                ),
              ),
            ),
            Positioned(
              left: widget.lightness * (widget.width - widget.thumbSize),
              child: ScaleTransition(
                scale: _scaleController,
                child: _Thumb(
                  size: 25,
                  color: HSLColor.fromAHSL(
                    1,
                    widget.hue,
                    1,
                    widget.lightness,
                  ).toColor(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      value: 1,
      lowerBound: 0.9,
      upperBound: 1,
      duration: const Duration(milliseconds: 50),
    );
  }

  void _onDown(DragDownDetails details) {
    _scaleController.reverse();
    widget.onChanged(details.localPosition.dx / widget.width);
  }

  void _onStart(DragStartDetails details) {
    _cancelTimer?.cancel();
    _cancelTimer = null;
    widget.onChanged(details.localPosition.dx / widget.width);
  }

  void _onUpdate(DragUpdateDetails details) {
    widget.onChanged(details.localPosition.dx / widget.width);
  }

  void _onEnd(DragEndDetails details) {
    _scaleController.forward();
    widget.onEnded();
  }

  void _onCancel() {
    // ScaleDown Animation cancelled if onDragStart called immediately
    _cancelTimer = Timer(
      const Duration(milliseconds: 5),
      () {
        _scaleController.forward();
        widget.onEnded();
      },
    );
  }
}

class _HuePicker extends StatefulWidget {
  const _HuePicker({
    Key? key,
    required this.hue,
    required this.onChanged,
    required this.onEnded,
    required this.size,
    required this.strokeWidth,
    required this.thumbSize,
  }) : super(key: key);

  final double hue;

  final ValueChanged<double> onChanged;

  final VoidCallback onEnded;

  final Size size;

  final double strokeWidth;

  final double thumbSize;

  @override
  _HuePickerState createState() => _HuePickerState();
}

class _HuePickerState extends State<_HuePicker> with TickerProviderStateMixin {
  late AnimationController _scaleController;
  Timer? _cancelTimer;

  @override
  Widget build(BuildContext context) {
    final minSize = min(widget.size.width, widget.size.height);
    final offset = _CircleTween(
      minSize / 2 - widget.thumbSize / 2,
    ).lerp(widget.hue * pi / 180);
    return GestureDetector(
      onPanDown: _onDown,
      onPanCancel: _onCancel,
      onHorizontalDragStart: _onStart,
      onHorizontalDragUpdate: _onUpdate,
      onHorizontalDragEnd: _onEnd,
      onVerticalDragStart: _onStart,
      onVerticalDragUpdate: _onUpdate,
      onVerticalDragEnd: _onEnd,
      child: SizedBox(
        width: widget.size.width,
        height: widget.size.height,
        child: Stack(
          children: <Widget>[
            SizedBox.expand(
              child: Padding(
                padding: EdgeInsets.all(
                  widget.thumbSize / 2 - widget.strokeWidth,
                ),
                child: CustomPaint(
                  painter: _CirclePickerPainter(widget.strokeWidth),
                ),
              ),
            ),
            Positioned(
              left: offset.dx,
              top: offset.dy,
              child: ScaleTransition(
                scale: _scaleController,
                child: _Thumb(
                  size: widget.thumbSize,
                  color: HSLColor.fromAHSL(1, widget.hue, 1, 0.5).toColor(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
      vsync: this,
      value: 1,
      lowerBound: 0.9,
      upperBound: 1,
      duration: const Duration(milliseconds: 50),
    );
  }

  void _onDown(DragDownDetails details) {
    _scaleController.reverse();
    _updatePosition(details.localPosition);
  }

  void _onStart(DragStartDetails details) {
    _cancelTimer?.cancel();
    _cancelTimer = null;
    _updatePosition(details.localPosition);
  }

  void _onUpdate(DragUpdateDetails details) {
    _updatePosition(details.localPosition);
  }

  void _onEnd(DragEndDetails details) {
    _scaleController.forward();
    widget.onEnded();
  }

  void _onCancel() {
    // ScaleDown Animation cancelled if onDragStart called immediately
    _cancelTimer = Timer(
      const Duration(milliseconds: 5),
      () {
        _scaleController.forward();
        widget.onEnded();
      },
    );
  }

  void _updatePosition(Offset position) {
    final radians = atan2(
      position.dy - widget.size.height / 2,
      position.dx - widget.size.width / 2,
    );
    widget.onChanged(radians % (2 * pi) * 180 / pi);
  }
}

class _CircleTween extends Tween<Offset> {
  _CircleTween(this.radius)
      : super(
          begin: _radiansToOffset(0, radius),
          end: _radiansToOffset(2 * pi, radius),
        );

  final double radius;

  @override
  Offset lerp(double t) => _radiansToOffset(t, radius);

  static Offset _radiansToOffset(double radians, double radius) {
    return Offset(
      radius + radius * cos(radians),
      radius + radius * sin(radians),
    );
  }
}

class _CirclePickerPainter extends CustomPainter {
  const _CirclePickerPainter(
    this.strokeWidth,
  );

  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    Offset center = Offset(size.width / 2, size.height / 2);
    double radio = min(size.width, size.height) / 2 - strokeWidth;

    const sweepGradient = SweepGradient(
      colors: const [
        Color.fromARGB(255, 255, 0, 0),
        Color.fromARGB(255, 255, 255, 0),
        Color.fromARGB(255, 0, 255, 0),
        Color.fromARGB(255, 0, 255, 255),
        Color.fromARGB(255, 0, 0, 255),
        Color.fromARGB(255, 255, 0, 255),
        Color.fromARGB(255, 255, 0, 0),
      ],
    );

    final sweepShader = sweepGradient.createShader(
      Rect.fromCircle(center: center, radius: radio),
    );

    canvas.drawCircle(
      center,
      radio,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth * 2
        ..shader = sweepShader,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class _Thumb extends StatelessWidget {
  const _Thumb({
    Key? key,
    required this.size,
    required this.color,
  }) : super(key: key);

  final double size;

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color.fromARGB(255, 255, 255, 255),
        boxShadow: [
          const BoxShadow(
            color: Color.fromARGB(16, 0, 0, 0),
            blurRadius: 4,
            spreadRadius: 4,
          )
        ],
      ),
      alignment: Alignment.center,
      child: Container(
        width: size - 6,
        height: size - 6,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
      ),
    );
  }
}
