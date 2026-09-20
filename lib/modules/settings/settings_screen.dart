import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';
import 'package:gitplus_for_gitlab/shared/shared.dart';

import 'settings.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _controller = Get.find<SettingsController>();

  final Map<String, String> _codeSnippets = {
    'Dart': '''
void main() {
  final name = "Git+";
  print("Hello \$name!");
  // This is a comment
}
''',
    'Python': '''
def hello():
    name = "Git+"
    print(f"Hello {name}!")
    # This is a comment
''',
    'Java': '''
public class Main {
    public static void main(String[] args) {
        String name = "Git+";
        System.out.println("Hello " + name);
        // This is a comment
    }
}
''',
    'C': '''
#include <stdio.h>
int main() {
    char* name = "Git+";
    printf("Hello %s\\n", name);
    /* This is a comment */
    return 0;
}
''',
  };

  String _selectedLang = 'Dart';

  @override
  void initState() {
    super.initState();
    _selectedLang = _controller.spStorage.getSelectedLanguage().value;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => _buildWidget(context));
  }

  Widget _buildWidget(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CrossFade<String>(
          initialData: '',
          data: 'Settings',
          builder: (value) => Text(value),
        ),
      ),
      body: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    var code = "";
    code = Get.isDarkMode ? AppCodeTheme.dark : AppCodeTheme.light;
    // ignore: unused_local_variable
    var x = _controller.updateUI.value;

    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        children: [
          const SizedBox(height: 12),
          _sectionHeader('General'),
          CardListItem(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.dark_mode_outlined),
                  title: const Text('Dark mode'),
                  subtitle: Text(_controller.theme.value),
                  trailing: const Icon(Icons.chevron_right, size: 20),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Dark mode'.tr),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                selected: _controller.spStorage.getTheme().value == AppTheme.dark,
                                title: Text('On'.tr),
                                trailing: _controller.spStorage.getTheme().value == AppTheme.dark ? const Icon(Icons.check) : null,
                                onTap: () {
                                  _controller.changeThemeValue(AppTheme.dark);
                                  Get.back();
                                },
                              ),
                              ListTile(
                                selected: _controller.spStorage.getTheme().value == AppTheme.light,
                                title: Text('Off'.tr),
                                trailing: _controller.spStorage.getTheme().value == AppTheme.light ? const Icon(Icons.check) : null,
                                onTap: () {
                                  _controller.changeThemeValue(AppTheme.light);
                                  Get.back();
                                },
                              ),
                              ListTile(
                                selected: _controller.spStorage.getTheme().value == AppTheme.system,
                                title: Text('System'.tr),
                                trailing: _controller.spStorage.getTheme().value == AppTheme.system ? const Icon(Icons.check) : null,
                                onTap: () {
                                  _controller.changeThemeValue(AppTheme.system);
                                  Get.back();
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.wallpaper_outlined),
                  title: const Text('Use wallpaper colors'),
                  subtitle: const Text('Use system dynamic color'),
                  trailing: AppSwitch(
                      value: _controller.spStorage.getUseDynamicColor().value,
                      onChanged: (value) {
                        _controller.onUseDynamicColorChanged(value);
                      }),
                ),
                ListTile(
                  leading: const Icon(Icons.palette_outlined),
                  title: const Text('Custom app color'),
                  subtitle: const Text('Choose a custom seed color'),
                  trailing: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: Color(_controller.spStorage.getCustomColorSeed().value),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Theme.of(context).dividerColor,
                        width: 1,
                      ),
                    ),
                  ),
                  enabled: !_controller.spStorage.getUseDynamicColor().value,
                  onTap: () {
                    _showColorPicker(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.tonality_outlined),
                  title: const Text('Monochrome icons'),
                  subtitle: const Text('Uniform icon colors based on theme'),
                  trailing: AppSwitch(
                      value: _controller.spStorage.getMonochromeIcons().value,
                      onChanged: (value) {
                        _controller.onMonochromeIconsChanged(value);
                      }),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _sectionHeader('Code'),
          CardListItem(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.format_list_numbered),
                  title: const Text('Show line numbers'),
                  trailing: AppSwitch(
                      value: _controller.spStorage.getShowLineNumbers().value,
                      onChanged: (value) {
                        _controller.onShowLineNumbersChanged(value);
                      }),
                ),
                _fontSize(),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _sectionHeader('Language & Preview'),
          CardListItem(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Icon(Icons.code_outlined, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Language: $_selectedLang',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                      TextButton(
                        onPressed: _showLanguagePicker,
                        child: const Text('Change'),
                      ),
                    ],
                  ),
                ),
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: AppHighlightView(
                      content: _codeSnippets[_selectedLang]!,
                      lang: _selectedLang.toLowerCase(),
                      fontSize: _controller.fontSize.value,
                      theme: code,
                      lineNumbers: _controller.spStorage.getShowLineNumbers().value,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _sectionHeader('Custom Syntax Colors'),
          CardListItem(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.color_lens_outlined),
                  title: const Text('Keyword Color'),
                  trailing: CircleAvatar(
                    radius: 12,
                    backgroundColor: Color(_controller.spStorage.prefs.getInt('syntax_keyword_color') ?? 0xFF569CD6),
                  ),
                  onTap: () => _showSyntaxColorPicker('keyword', 'Keyword', 0xFF569CD6),
                ),
                ListTile(
                  leading: const Icon(Icons.color_lens_outlined),
                  title: const Text('String Color'),
                  trailing: CircleAvatar(
                    radius: 12,
                    backgroundColor: Color(_controller.spStorage.prefs.getInt('syntax_string_color') ?? 0xFFCE9178),
                  ),
                  onTap: () => _showSyntaxColorPicker('string', 'String', 0xFFCE9178),
                ),
                ListTile(
                  leading: const Icon(Icons.color_lens_outlined),
                  title: const Text('Comment Color'),
                  trailing: CircleAvatar(
                    radius: 12,
                    backgroundColor: Color(_controller.spStorage.prefs.getInt('syntax_comment_color') ?? 0xFF6A9955),
                  ),
                  onTap: () => _showSyntaxColorPicker('comment', 'Comment', 0xFF6A9955),
                ),
                ListTile(
                  title: const Text('Reset Syntax Colors', style: TextStyle(color: Colors.orange)),
                  trailing: const Icon(Icons.refresh, color: Colors.orange),
                  onTap: () => _controller.onResetSyntaxColors(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          ListTile(
            title: Text('Reset defaults'.tr,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => QuestionMessagePresetsDialog(
                  title: 'Reset settings'.tr,
                  text: 'This will reset your settings. No data will be deleted'
                      .tr,
                  action: () async {
                    await _controller.onResetDefault();
                  },
                ),
              );
            },
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _fontSize() {
    return Column(
      children: [
        Padding(
          padding:
              const EdgeInsets.only(left: 15, top: 15, bottom: 5, right: 15),
          child: Row(
            children: [
              const Text('Font size:', style: TextStyle(fontSize: 16)),
              const SizedBox(width: 5),
              Text(_controller.fontSize.value.toInt().toString(),
                  style: const TextStyle(fontSize: 16)),
            ],
          ),
        ),
        Slider(
          value: _controller.fontSize.value,
          year2023: false,
          onChangeEnd: (value) {
            _controller.onFontSizeChangedEnd(value);
          },
          onChanged: (value) {
            _controller.onFontSizeChanged(value);
          },
          min: 8,
          max: 30,
          // divisions: 45,
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _sectionHeader(String text) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Text(text,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }

  void _showColorPicker(BuildContext context) {
    Color pickerColor = Color(_controller.spStorage.getCustomColorSeed().value);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pick a color'.tr),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: pickerColor,
              onColorChanged: (Color color) {
                pickerColor = color;
              },
              paletteType: PaletteType.hueWheel,
              displayThumbColor: true,
              enableAlpha: false,
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text('Cancel'.tr),
            ),
            ElevatedButton(
              onPressed: () {
                _controller.onCustomColorSeedChanged(pickerColor);
                Get.back();
              },
              child: Text('Apply'.tr),
            ),
          ],
        );
      },
    );
  }

  void _showLanguagePicker() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: _codeSnippets.keys.map((lang) {
              return ListTile(
                title: Text(lang),
                trailing: _selectedLang == lang ? const Icon(Icons.check, color: Colors.green) : null,
                onTap: () {
                  setState(() {
                    _selectedLang = lang;
                  });
                  _controller.onSelectedLanguageChanged(lang);
                  Get.back();
                },
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  void _showSyntaxColorPicker(String key, String title, int defaultColor) {
    int? currentVal = _controller.spStorage.prefs.getInt('syntax_${key}_color');
    Color pickerColor = currentVal != null ? Color(currentVal) : Color(defaultColor);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pick $title Color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: pickerColor,
              onColorChanged: (Color color) {
                pickerColor = color;
              },
              paletteType: PaletteType.hueWheel,
              displayThumbColor: true,
              enableAlpha: false,
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text('Cancel'.tr),
            ),
            ElevatedButton(
              onPressed: () {
                _controller.onSyntaxColorChanged(key, pickerColor);
                Get.back();
              },
              child: Text('OK'.tr),
            ),
          ],
        );
      },
    );
  }
}
