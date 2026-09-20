import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gitplus_for_gitlab/shared/shared.dart';

import 'create_merge_request_controller.dart';

class CreateMergeRequestScreen extends GetView<CreateMergeRequestController> {
  const CreateMergeRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => _buildWidget(context));
  }

  Widget _buildWidget(context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New merge request'.tr),
      ),
      body: SafeArea(child: _buildForm(context)),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.onSave();
        },
        tooltip: 'Add'.tr,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildForm(context) {
    return Form(
      key: controller.registerFormKey,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        children: [
          const SizedBox(height: 16),
          _sectionHeader('Merge Request Details'),
          CardListItem(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  InputField(
                    labelText: "Title".tr,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Title is required.'.tr;
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
                  MultilineInputField(
                      context: context,
                      labelText: "Description".tr,
                      controller: controller.descriptionController),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          _sectionHeader('Branches & Assignment'),
          CardListItem(
            child: Column(
              children: [
                ListTile(
                  title: Text('Source branch'.tr),
                  trailing: IconButton(
                    onPressed: () {
                      showSearch(
                          context: context, delegate: BranchSearch(controller, true));
                    },
                    icon: controller.sourceBranch.value.isEmpty
                        ? const Icon(Icons.add)
                        : const Icon(Icons.search),
                    tooltip: controller.sourceBranch.value.isEmpty
                        ? 'Add'.tr
                        : 'Change'.tr,
                  ),
                  subtitle: controller.sourceBranch.value.isEmpty ? null : Wrap(
                    spacing: 10,
                    children: [
                      if (controller.sourceBranch.value.isNotEmpty)
                        Chip(label: Text(controller.sourceBranch.value)),
                    ],
                  ),
                ),
                ListTile(
                  title: Text('Target branch'.tr),
                  trailing: IconButton(
                    onPressed: () {
                      showSearch(
                          context: context,
                          delegate: BranchSearch(controller, false));
                    },
                    icon: controller.targetBranch.value.isEmpty
                        ? const Icon(Icons.add)
                        : const Icon(Icons.search),
                    tooltip: controller.targetBranch.value.isEmpty
                        ? 'Add'.tr
                        : 'Change'.tr,
                  ),
                  subtitle: controller.targetBranch.value.isEmpty ? null : Wrap(
                    spacing: 10,
                    children: [
                      if (controller.targetBranch.value.isNotEmpty)
                        Chip(label: Text(controller.targetBranch.value)),
                    ],
                  ),
                ),
                ListTile(
                  title: Text('Assigned'.tr),
                  trailing: IconButton(
                    onPressed: () {
                      showSearch(context: context, delegate: UserSearch(controller));
                    },
                    icon: controller.assignee.value.id == null
                        ? const Icon(Icons.add)
                        : const Icon(Icons.search),
                    tooltip:
                        controller.assignee.value.id == null ? 'Add'.tr : 'Change'.tr,
                  ),
                  subtitle: controller.assignee.value.id == null ? null : Wrap(
                    spacing: 10,
                    children: [
                      if (controller.assignee.value.id != null &&
                          controller.assignee.value.id! > 0)
                        InputChip(
                          avatar: ListAvatar(
                              avatarUrl: controller.assignee.value.avatarUrl!),
                          label: Text(controller.assignee.value.name!),
                          deleteIcon: const Icon(Icons.remove_circle_outline,
                              color: Colors.red),
                          onDeleted: () {
                            controller.onAssigeeDeleted();
                          },
                        ),
                    ],
                  ),
                ),
              ],
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

class UserSearch extends SearchDelegate<String> {
  late final CreateMergeRequestController controller;

  UserSearch(this.controller)
      : super(
          searchFieldStyle: const TextStyle(color: Colors.grey),
          searchFieldLabel: 'Search user'.tr,
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
    controller.onUserSearchTextChanged(query);
    return _usersListWidget(context, controller);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    controller.onUserSearchTextChanged(query);
    return _usersListWidget(context, controller);
  }
}

class BranchSearch extends SearchDelegate<String> {
  late final CreateMergeRequestController controller;
  late final bool isSource;

  BranchSearch(this.controller, this.isSource)
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
    return _branchesListWidget(context, controller, isSource);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    controller.onBranchSearchTextChanged(query);
    return _branchesListWidget(context, controller, isSource);
  }
}

Widget _usersListWidget(
    BuildContext context, CreateMergeRequestController controller) {
  return Obx(
    () => ListView.builder(
      controller: controller.usersScrollController,
      itemCount: controller.users.length,
      itemBuilder: (context, index) {
        var item = controller.users[index];

        return ListTile(
          leading: ListAvatar(avatarUrl: item.avatarUrl!),
          title: Text(item.name!),
          subtitle: Text(item.username!),
          onTap: () {
            controller.onUserSelected(item);
            Get.back();
          },
        );
      },
    ),
  );
}

Widget _branchesListWidget(BuildContext context,
    CreateMergeRequestController controller, bool isSource) {
  return Obx(
    () => ListView.builder(
      controller: controller.branchesScrollController,
      itemCount: controller.branches.length,
      itemBuilder: (context, index) {
        var item = controller.branches[index];

        return ListTile(
          title: Text(item.name!),
          onTap: () {
            if (isSource) {
              controller.onSourceBranchSelected(item);
            } else {
              controller.onTargetBranchSelected(item);
            }
            Get.back();
          },
        );
      },
    ),
  );
}
