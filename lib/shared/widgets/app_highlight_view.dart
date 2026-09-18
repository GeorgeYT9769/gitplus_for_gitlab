import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gitplus_for_gitlab/shared/shared.dart';
import 'package:gitplus_for_gitlab/shared/flutter_highlight/flutter_highlight.dart';
import 'package:gitplus_for_gitlab/shared/flutter_highlight/theme_map.dart';

class AppHighlightView extends StatelessWidget {
  final String? content;
  final String lang;
  final double? fontSize;
  final String? theme;
  final bool? lineNumbers;


  const AppHighlightView({
    super.key,
    this.content,
    required this.lang,
    this.fontSize,
    this.theme,
    this.lineNumbers = true,
  });


  @override
  Widget build(BuildContext context) {
    final numLines = '\n'.allMatches(content ?? '').length + 1;
    final Map<String, TextStyle> themeData = Map<String, TextStyle>.from(themeMap[theme] ?? {});
    
    // Inject custom colors if configured
    try {
      final sp = Get.find<SPStorage>();
      final customKeyword = sp.prefs.getInt('syntax_keyword_color');
      final customString = sp.prefs.getInt('syntax_string_color');
      final customComment = sp.prefs.getInt('syntax_comment_color');
      
      if (customKeyword != null) {
        themeData['keyword'] = (themeData['keyword'] ?? const TextStyle()).copyWith(color: Color(customKeyword));
      }
      if (customString != null) {
        themeData['string'] = (themeData['string'] ?? const TextStyle()).copyWith(color: Color(customString));
      }
      if (customComment != null) {
        themeData['comment'] = (themeData['comment'] ?? const TextStyle()).copyWith(color: Color(customComment));
      }
    } catch (_) {}

    final style = TextStyle(
      fontFamily: 'SourceCodePro',
      fontSize: fontSize,
      height: 1.5,
      leadingDistribution: TextLeadingDistribution.even,
    );

    return content == null || content!.isEmpty
        ? Container()
        : Container(
            color: themeData['root']?.backgroundColor ?? const Color(0xffffffff),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (lineNumbers!)
                  Padding(
                    padding: const EdgeInsets.only(top: 15, left: 10),
                    child: Text(
                      List.generate(numLines, (i) => (i + 1).toString())
                          .join('\n'),
                      textAlign: TextAlign.right,
                      textHeightBehavior: const TextHeightBehavior(
                        applyHeightToFirstAscent: false,
                        applyHeightToLastDescent: false,
                      ),
                      strutStyle: StrutStyle(
                        fontFamily: style.fontFamily,
                        fontSize: style.fontSize,
                        height: style.height,
                        leadingDistribution: style.leadingDistribution,
                        forceStrutHeight: true,
                      ),
                      style: style.copyWith(
                          color: Get.theme.hintColor.withValues(alpha: 0.5)),
                    ),
                  ),
                GestureDetector(
                  onDoubleTap: () {
                    Clipboard.setData(ClipboardData(text: content as String));
                    CommonWidget.toast('Copied to Clipboard');
                  },
                  child: HighlightView(
                    content!,
                    language: lang,
                    theme: themeData,
                    padding: const EdgeInsets.all(15),
                    textStyle: style,
                    tabSize: 4,
                  ),
                ),
              ],
            ),
          );
  }
}
