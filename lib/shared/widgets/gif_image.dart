import 'package:flutter/widgets.dart';

import 'gif_image_stub.dart' if (dart.library.html) 'gif_image_web.dart' as platform;

typedef GifWidgetBuilder = Widget Function(BuildContext context);
typedef GifErrorWidgetBuilder = Widget Function(BuildContext context, Object error);

/// Renders a (typically animated) GIF from [url].
///
/// On web this renders via a real DOM `<img>` element instead of
/// `CachedNetworkImage`: Flutter Web's CanvasKit/Skwasm renderer fetches raw
/// image bytes over XHR to decode+composite onto the canvas, which browsers
/// block via CORS unless the server sends `Access-Control-Allow-Origin`. A
/// plain `<img>` tag displays the same cross-origin response fine because
/// the browser never needs script-level access to the pixel bytes.
/// Non-web platforms have no CORS layer, so they keep using
/// `CachedNetworkImage` unchanged.
class GifImage extends StatelessWidget {
  const GifImage({
    super.key,
    required this.url,
    this.fit = BoxFit.cover,
    required this.placeholder,
    required this.errorWidget,
  });

  final String url;
  final BoxFit fit;
  final GifWidgetBuilder placeholder;
  final GifErrorWidgetBuilder errorWidget;

  @override
  Widget build(BuildContext context) => platform.buildGifImage(
        context: context,
        url: url,
        fit: fit,
        placeholder: placeholder,
        errorWidget: errorWidget,
      );
}
