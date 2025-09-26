import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rive/math.dart';
import 'package:rive/rive.dart';
import 'package:sizer/sizer.dart';


class MyRiveAnimation extends StatefulWidget {
  final String level;
  final Color? color;
  final Color? previeColor;
  final bool isChangeColor;

  const MyRiveAnimation({
    super.key,
    this.level = "nivel_0",
    this.color,
    this.isChangeColor = false, 
    this.previeColor,
  });

  @override
  _MyRiveAnimationState createState() => _MyRiveAnimationState();
}

class _MyRiveAnimationState extends State<MyRiveAnimation> with SingleTickerProviderStateMixin {
  final ValueNotifier<Artboard?> _artboardNotifier = ValueNotifier(null);
  RiveAnimationController? _controller;
  AnimationController? _colorController;

  @override
  void initState() {
    super.initState();
    _colorController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5), // Duración de la transición
    );

    _loadAnimation();
  }

  @override
  void dispose() {
    _colorController?.dispose();
    _controller?.dispose();
    _artboardNotifier.dispose();
    super.dispose();
  }

  Future<void> _loadAnimation() async {
    try {
      var file = await RiveFile.asset('assets/medalla_formarte.riv');
      var artboard = file.mainArtboard;
      _controller = SimpleAnimation(widget.level);
      artboard.addController(_controller!);

      _artboardNotifier.value = artboard;
    } catch (e) {
      debugPrint('Error loading Rive animation: $e');
    }
  }


List<RiveAnimationController> _getControllersForLevel(String level) {
  List<RiveAnimationController> controllers = [];
  int levelNumber = int.tryParse(level.split('_').last) ?? 0;

  for (int i = 0; i <= levelNumber; i++) {
    controllers.add(SimpleAnimation('nivel_$i'));
  }

  return controllers;
}


  void _startAnimations() {
    if (mounted) {
      _colorController?.forward(from: 0);
      _controller?.isActive = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Artboard?>(
      valueListenable: _artboardNotifier,
      builder: (context, artboard, _) {
        return Stack(
          children: [
            if (artboard != null)
              SizedBox(
                width: 100.w,
                height: 100.w,
                child: RiveColorModifier(
                  artboard: artboard,
                  fit: BoxFit.contain,
                  components: [if (widget.color != null) ...all(widget.color!)],
                ),
              ),
          ],
        );
      },
    );
  }

  List<RiveColorComponent> all(Color color) {
    return [
      ...level(color),
      if (widget.level == "nivel_3"||widget.previeColor!=null)
        RiveColorComponent(
          shapeName: 'medallon',
          fillName: '',
        color:widget.level == "nivel_3"?color:widget.previeColor??color,
        ),
      if (widget.level == "nivel_3"||widget.previeColor!=null) ...llama(color),
    ];
  }

  List<RiveColorComponent> llama(Color color) {
    return List.generate(
      6,
      (i) => RiveColorComponent(
        shapeName: 'llama_${i + 1}',
        fillName: '',
        color:widget.level == "nivel_3"?color:widget.previeColor??color,
      ),
    );
  }

  List<RiveColorComponent> level(Color color) {
    return List.generate(
      3,
      (i) => RiveColorComponent(
        shapeName: 'nivel_${i + 1}',
        fillName: '',
        color: color,
      ),
    );
  }
}

class RiveColorComponent {
  final String shapeName;
  final String fillName;
  final Color color;
  Shape? shape;
  Fill? fill;

  RiveColorComponent({
    required this.shapeName,
    required this.fillName,
    required this.color,
  });

  @override
  bool operator ==(covariant RiveColorComponent other) {
    if (identical(this, other)) return true;

    return other.fillName == fillName &&
        other.shapeName == shapeName &&
        other.color == color;
  }

  @override
  int get hashCode {
    return fillName.hashCode ^ shapeName.hashCode ^ color.hashCode;
  }
}

class RiveColorModifier extends LeafRenderObjectWidget {
  final Artboard artboard;
  final BoxFit fit;
  final Alignment alignment;
  final List<RiveColorComponent> components;

  const RiveColorModifier({
    super.key,
    required this.artboard,
    this.fit = BoxFit.contain,
    this.alignment = Alignment.center,
    this.components = const [],
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RiveCustomRenderObject(artboard as RuntimeArtboard)
      ..artboard = artboard
      ..fit = fit
      ..alignment = alignment
      ..components = components;
  }

  @override
  void updateRenderObject(BuildContext context, covariant RiveCustomRenderObject renderObject) {
    renderObject
      ..artboard = artboard
      ..fit = fit
      ..alignment = alignment
      ..components = components;
  }

  @override
  void didUnmountRenderObject(covariant RiveCustomRenderObject renderObject) {
    renderObject.dispose();
  }
}

class RiveCustomRenderObject extends RiveRenderObject {
  List<RiveColorComponent> _components = [];
  bool _isDisposed = false;

  RiveCustomRenderObject(super.artboard);

  List<RiveColorComponent> get components => _components;

  set components(List<RiveColorComponent> value) {
    if (listEquals(_components, value)) {
      return;
    }
    _components = value;

    for (final component in _components) {
      component.shape = artboard.objects.firstWhereOrNull(
        (element) => element is Shape && element.name == component.shapeName,
      ) as Shape?;

      if (component.shape != null) {
        component.fill = component.shape!.fills
            .firstWhereOrNull((element) => element.name == component.fillName);
        if (component.fill == null) {
          throw Exception("Could not find fill named: ${component.fillName}");
        }
      } else {
        throw Exception("Could not find shape named: ${component.shapeName}");
      }
    }
    markNeedsPaint();
  }

  @override
  void dispose() {
    if (_isDisposed) return;
    _isDisposed = true;
    super.dispose();
  }

  @override
  void draw(Canvas canvas, Mat2D viewTransform) {
    for (final component in _components) {
      if (component.fill == null) return;

      component.fill!.paint.color =
          component.color.withAlpha(component.fill!.paint.color.alpha);
    }

    super.draw(canvas, viewTransform);
  }
}