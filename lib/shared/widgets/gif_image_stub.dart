import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';

import 'gif_image.dart';

Widget buildGifImage({
  required BuildContext context,
  required String url,
  required BoxFit fit,
  required GifWidgetBuilder placeholder,
  required GifErrorWidgetBuilder errorWidget,
}) {
  return CachedNetworkImage(
    imageUrl: url,
    fit: fit,
    placeholder: (ctx, _) => placeholder(ctx),
    errorWidget: (ctx, _, error) => errorWidget(ctx, error),
  );
}
