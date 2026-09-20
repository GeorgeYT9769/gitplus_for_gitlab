import 'package:flutter/material.dart';
import 'package:gitplus_for_gitlab/models/models.dart';
import 'package:gitplus_for_gitlab/shared/shared.dart';

import 'package:get/get.dart';

import 'create_project_snippet.dart';

class SnippetVisibilityItemItem {
  final String name;
  final String value;

  SnippetVisibilityItemItem({
    required this.name,
    required this.value,
  });
}

class CreateProjectSnippetScreen
    extends GetView<CreateProjectSnippetController> {
  const CreateProjectSnippetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildWidget(context);
  }

  Widget _buildWidget(context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New snippet'.tr),
      ),
      body: _buildForm(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.add();
        },
        tooltip: 'Add'.tr,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildForm(context) {
    var vis = "";
    switch (controller.visibility.value) {
      case GitLabVisibility.private:
        vis = "Private";
        break;
      case GitLabVisibility.internal:
        vis = "Internal";
        break;
      case GitLabVisibility.public:
        vis = "Public";
        break;
    }
    return Form(
      key: controller.registerFormKey,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        children: [
          const SizedBox(height: 16),
          _sectionHeader('Snippet Information'),
          CardListItem(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  InputField(
                    labelText: "Title".tr,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'this field is required.'.tr;
                      }
                      return null;
                    },
                    context: context,
                    controller: controller.titleController,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    onChanged: (value) {},
                  ),
                  const SizedBox(height: 8),
                  InputField(
                    labelText: "Filename".tr,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'this field is required.'.tr;
                      }
                      return null;
                    },
                    context: context,
                    controller: controller.filenameController,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    onChanged: (value) {},
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          _sectionHeader('Code Content'),
          CardListItem(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: MultilineInputField(
                context: context,
                labelText: "Code".tr,
                controller: controller.codeController,
              ),
            ),
          ),
          const SizedBox(height: 16),
          _sectionHeader('Access Control'),
          CardListItem(
            child: ListTile(
              leading: const Icon(Icons.visibility_outlined),
              title: Text('Visibility'.tr),
              subtitle: Text(vis),
              trailing: const Icon(Icons.chevron_right, size: 20),
              onTap: () {
                AppFocus.nextFocus(context);
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Visibility'.tr),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            selected: controller.visibility.value ==
                                GitLabVisibility.private,
                            title: Text('Private'.tr),
                            trailing: controller.visibility.value == GitLabVisibility.private ? const Icon(Icons.check) : null,
                            onTap: () {
                              controller.onVisibilityChanged(
                                  GitLabVisibility.private);
                              Get.back();
                            },
                          ),
                          ListTile(
                            selected: controller.visibility.value ==
                                GitLabVisibility.internal,
                            title: Text('Internal'.tr),
                            trailing: controller.visibility.value == GitLabVisibility.internal ? const Icon(Icons.check) : null,
                            onTap: () {
                              controller.onVisibilityChanged(
                                  GitLabVisibility.internal);
                              Get.back();
                            },
                          ),
                          ListTile(
                            selected: controller.visibility.value ==
                                GitLabVisibility.public,
                            title: Text('Public'.tr),
                            trailing: controller.visibility.value == GitLabVisibility.public ? const Icon(Icons.check) : null,
                            onTap: () {
                              controller
                                  .onVisibilityChanged(GitLabVisibility.public);
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
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _sectionHeader(String text) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Text(
        text.tr,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: Get.theme.colorScheme.primary,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
