import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gitplus_for_gitlab/modules/edit_merge_request/edit_merge_request.dart';
import 'package:gitplus_for_gitlab/shared/shared.dart';

class EditMergeRequestScreen extends GetView<EditMergeRequestController> {
  const EditMergeRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => _buildWidget(context));
  }

  Widget _buildWidget(context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit merge request'.tr),
      ),
      body: SafeArea(child: _buildForm(context)),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.onSave();
        },
        tooltip: 'Save'.tr,
        child: const Icon(Icons.save_outlined),
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
                  title: Text('Target branch'.tr),
                  trailing: IconButton(
                    onPressed: () {
                      showSearch(
                          context: context, delegate: BranchSearch(controller));
                    },
                    icon: controller.branch.value.isEmpty
                        ? const Icon(Icons.add)
                        : const Icon(Icons.search),
                    tooltip: controller.branch.value.isEmpty ? 'Add'.tr : 'Change'.tr,
                  ),
                  subtitle: controller.branch.value.isEmpty ? null : Wrap(
                    spacing: 10,
                    children: [
                      if (controller.branch.value.isNotEmpty)
                        Chip(label: Text(controller.branch.value)),
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
  late final EditMergeRequestController controller;

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
  late final EditMergeRequestController controller;

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

Widget _usersListWidget(
    BuildContext context, EditMergeRequestController controller) {
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

Widget _branchesListWidget(
    BuildContext context, EditMergeRequestController controller) {
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
