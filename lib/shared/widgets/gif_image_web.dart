import 'dart:js_interop';
import 'dart:ui_web' as ui_web;

import 'package:flutter/widgets.dart';
import 'package:web/web.dart' as web;

import 'gif_image.dart';

Widget buildGifImage({
  required BuildContext context,
  required String url,
  required BoxFit fit,
  required GifWidgetBuilder placeholder,
  required GifErrorWidgetBuilder errorWidget,
}) {
  return _WebGifImage(url: url, fit: fit, placeholder: placeholder, errorWidget: errorWidget);
}

String _cssObjectFit(BoxFit fit) => switch (fit) {
      BoxFit.contain => 'contain',
      BoxFit.fill => 'fill',
      BoxFit.none => 'none',
      _ => 'cover',
    };

class _WebGifImage extends StatefulWidget {
  const _WebGifImage({
    required this.url,
    required this.fit,
    required this.placeholder,
    required this.errorWidget,
  });

  final String url;
  final BoxFit fit;
  final GifWidgetBuilder placeholder;
  final GifErrorWidgetBuilder errorWidget;

  @override
  State<_WebGifImage> createState() => _WebGifImageState();
}

class _WebGifImageState extends State<_WebGifImage> {
  late String _viewType;
  bool _loaded = false;
  Object? _error;

  @override
  void initState() {
    super.initState();
    _registerView();
  }

  @override
  void didUpdateWidget(covariant _WebGifImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url) {
      _loaded = false;
      _error = null;
      _registerView();
    }
  }

  void _registerView() {
    _viewType = 'ct-gif-${widget.url.hashCode}-${identityHashCode(this)}';
    ui_web.platformViewRegistry.registerViewFactory(_viewType, (int viewId) {
      final img = web.HTMLImageElement()
        ..src = widget.url
        ..style.width = '100%'
        ..style.height = '100%'
        ..style.objectFit = _cssObjectFit(widget.fit)
        ..style.border = 'none';
      img.addEventListener(
        'load',
        (web.Event event) {
          if (mounted) setState(() => _loaded = true);
        }.toJS,
      );
      img.addEventListener(
        'error',
        (web.Event event) {
          if (mounted) setState(() => _error = 'GIF failed to load');
        }.toJS,
      );
      return img;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) return widget.errorWidget(context, _error!);
    return Stack(
      fit: StackFit.expand,
      children: [
        HtmlElementView(viewType: _viewType),
        if (!_loaded) widget.placeholder(context),
      ],
    );
  }
}
