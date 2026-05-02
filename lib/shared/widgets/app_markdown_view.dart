import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_utils/src/get_utils/get_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class AppMarkdown extends StatelessWidget {
  final String content;
  const AppMarkdown({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Markdown(
      data: content,
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      onTapLink: (text, href, title) {
        if (href == null || !GetUtils.isURL(href)) {
          return;
        }
        launchUrl(Uri.parse((href)));
      },
      sizedImageBuilder: (config) {
        var imageUrl = config.uri.toString();

        // shields.io SVGs often use textLength and transform="scale(.1)" which 
        // flutter_svg handles incorrectly, causing text to overflow the badge.
        // We rewrite the URL to use raster.shields.io which returns a PNG.
        if (!imageUrl.contains('raster.shields.io')) {
          if (imageUrl.contains('img.shields.io')) {
            imageUrl = imageUrl.replaceAll('img.shields.io', 'raster.shields.io');
          } else if (imageUrl.contains('shields.io')) {
            imageUrl = imageUrl.replaceAll('shields.io', 'raster.shields.io');
          }
        }

        final isSvg = (imageUrl.endsWith('.svg') ||
                imageUrl.contains('.svg?') ||
                imageUrl.contains('format=svg')) &&
            !imageUrl.contains('raster.shields.io');

        if (isSvg) {
          return SvgPicture.network(
            imageUrl,
            width: config.width,
            height: config.height,
            placeholderBuilder: (context) => Container(
              width: config.width,
              height: config.height,
              color: Colors.grey[200],
            ),
          );
        } else if (GetUtils.isURL(imageUrl)) {
          return CachedNetworkImage(
            imageUrl: imageUrl,
            width: config.width,
            height: config.height,
            errorWidget: (context, url, error) => const Icon(Icons.broken_image),
          );
        } else {
          return Container();
        }
      },
      physics: const NeverScrollableScrollPhysics(),
      styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
        code: const TextStyle(fontFamily: 'SourceCodePro'),
      ),
      onTapText: () {},
    );
  }
}
