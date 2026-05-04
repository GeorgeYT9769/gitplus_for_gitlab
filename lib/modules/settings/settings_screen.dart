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
  var name = "John";
  print(name);
}
''',
    'Python': '''
def main():
    name = "John"
    print(name)
''',
    'Java': '''
public class Main {
    public static void main(String[] args) {
        String name = "John";
        System.out.println(name);
    }
}
''',
    'C': '''
#include <stdio.h>
int main() {
    char name[] = "John";
    printf("%s\\n", name);
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
        children: [
          _sectionHeader('General'),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.dark_mode),
            title: const Text('Dark mode'),
            subtitle: Text(_controller.theme.value),
            trailing: const Icon(Icons.keyboard_arrow_right),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Dark mode'.tr),
                    content: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Divider(),
                          ListTile(
                            selected: _controller.spStorage.getTheme().value ==
                                AppTheme.dark,
                            title: Text('On'.tr),
                            onTap: () {
                              _controller.changeThemeValue(AppTheme.dark);
                              Get.back();
                            },
                          ),
                          const Divider(),
                          ListTile(
                            selected: _controller.spStorage.getTheme().value ==
                                AppTheme.light,
                            title: Text('Off'.tr),
                            onTap: () {
                              _controller.changeThemeValue(AppTheme.light);
                              Get.back();
                            },
                          ),
                          const Divider(),
                          ListTile(
                            selected: _controller.spStorage.getTheme().value ==
                                AppTheme.system,
                            title: Text('System'.tr),
                            onTap: () {
                              _controller.changeThemeValue(AppTheme.system);
                              Get.back();
                            },
                          ),
                          const Divider(),
                        ],
                      ),
                    ),
                    actions: [
                      ElevatedButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: Text('Cancel'.tr))
                    ],
                  );
                },
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.wallpaper),
            title: const Text('Use wallpaper colors'),
            subtitle: const Text('Use system dynamic color'),
            trailing: AppSwitch(
                value: _controller.spStorage.getUseDynamicColor().value,
                onChanged: (value) {
                  _controller.onUseDynamicColorChanged(value);
                }),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.palette),
            title: const Text('Custom app color'),
            subtitle: const Text('Choose a custom seed color'),
            trailing: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Color(_controller.spStorage.getCustomColorSeed().value),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).dividerColor,
                  width: 1.5,
                ),
              ),
            ),
            enabled: !_controller.spStorage.getUseDynamicColor().value,
            onTap: () {
              _showColorPicker(context);
            },
          ),
          const Divider(),
          _sectionHeader('Code'),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.format_list_numbered),
            title: const Text('Show line numbers'),
            trailing: AppSwitch(
                value: _controller.spStorage.getShowLineNumbers().value,
                onChanged: (value) {
                  _controller.onShowLineNumbersChanged(value);
                }),
          ),
          const Divider(),
          _fontSize(),
          const Divider(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: DropdownMenu<String>(
                  initialSelection: _selectedLang,
                  onSelected: (String? newLang) {
                    if (newLang != null) {
                      setState(() {
                        _selectedLang = newLang;
                      });
                      _controller.onSelectedLanguageChanged(newLang);
                    }
                  },
                  dropdownMenuEntries: _codeSnippets.keys
                      .map((lang) => DropdownMenuEntry<String>(
                    value: lang,
                    label: lang,
                    style: ButtonStyle(
                      textStyle: WidgetStateProperty.all(
                        Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ))
                      .toList(),
                  width: double.infinity,
                  menuStyle: MenuStyle(
                    backgroundColor: WidgetStateProperty.all(
                      Theme.of(context).colorScheme.surface,
                    ),
                    elevation: WidgetStateProperty.all(3),
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  textStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  inputDecorationTheme: InputDecorationTheme(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                        width: 2,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                        width: 2,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
              ),
              SafeArea(
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
          const Divider(),
          ListTile(
            title: Text('Reset defaults'.tr,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red)),
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
          const Divider(),
          const SizedBox(height: 25),
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
}
