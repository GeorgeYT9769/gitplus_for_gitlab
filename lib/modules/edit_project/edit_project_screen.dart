import 'package:flutter/material.dart';
import 'package:gitplus_for_gitlab/models/models.dart';
import 'package:gitplus_for_gitlab/models/types.dart';
import 'package:gitplus_for_gitlab/shared/shared.dart';

import 'package:get/get.dart';

import 'edit_project.dart';

class EditProjectScreen extends GetView<EditProjectController> {
  const EditProjectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => _buildWidget(context));
  }

  Widget _buildWidget(context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit project'.tr),
      ),
      body: SafeArea(child: _buildForm(context)),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.save();
        },
        tooltip: 'Save'.tr,
        child: const Icon(Icons.save),
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
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            _sectionHeader('Project Details'),
            CardListItem(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    InputField(
                      labelText: "Name".tr,
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
                      labelText: "Path".tr,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'this field is required.'.tr;
                        }
                        return null;
                      },
                      context: context,
                      controller: controller.pathController,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      onChanged: (value) {},
                    ),
                    const SizedBox(height: 8),
                    MultilineInputField(
                      labelText: "Description".tr,
                      context: context,
                      controller: controller.descriptionController,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            _sectionHeader('Configuration'),
            CardListItem(
              child: Column(
                children: [
                  ListTile(
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
                                    controller.onVisibilityChanged(
                                        GitLabVisibility.public);
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
                    leading: const Icon(Icons.account_tree_outlined),
                    title: Text('Default branch'.tr),
                    onTap: () {
                      showSearch(
                          context: context, delegate: BranchSearch(controller));
                    },
                    trailing: IconButton(
                      onPressed: () {
                        showSearch(
                            context: context, delegate: BranchSearch(controller));
                      },
                      icon: controller.branch.value.isEmpty
                          ? const Icon(Icons.add)
                          : const Icon(Icons.search),
                      tooltip:
                          controller.branch.value.isEmpty ? 'Add'.tr : 'Change'.tr,
                    ),
                    subtitle: controller.branch.value.isEmpty ? null : Wrap(
                      spacing: 10,
                      children: [
                        if (controller.branch.value.isNotEmpty)
                          Chip(label: Text(controller.branch.value)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 100)
          ],
        ),
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

class BranchSearch extends SearchDelegate<String> {
  late final EditProjectController controller;

  BranchSearch(this.controller)
      : super(
          searchFieldStyle: const TextStyle(color: Colors.grey),
          searchFieldLabel: 'Search branch'.tr,
        );

  @override
  ThemeData appBarTheme(BuildContext context) {
    final theme = Theme.of(context);
    return theme.copyWith(
      appBarTheme: theme.appBarTheme.copyWith(
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 16),
        border: InputBorder.none,
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = "";
        },
        icon: const Icon(Icons.close),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          Get.back();
        },
        icon: searchLeadingIcon());
  }

  @override
  Widget buildResults(BuildContext context) {
    controller.onBranchSearchTextChanged(query);
    return _branchesListWidget(context, controller);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    controller.onBranchSearchTextChanged(query);
    return _branchesListWidget(context, controller);
  }
}

Widget _branchesListWidget(
    BuildContext context, EditProjectController controller) {
  return Obx(
    () => ListView.builder(
      controller: controller.branchesScrollController,
      itemCount: controller.branches.length,
      itemBuilder: (context, index) {
        var item = controller.branches[index];

        return ListTile(
          title: Text(item.name!),
          onTap: () {
            controller.onBranchSelected(item);
            Get.back();
          },
        );
      },
    ),
  );
}
