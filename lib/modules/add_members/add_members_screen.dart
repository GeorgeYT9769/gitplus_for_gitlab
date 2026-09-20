import 'package:flutter/material.dart';
import 'package:gitplus_for_gitlab/shared/shared.dart';

import 'package:get/get.dart';

import 'add_members.dart';

class AccessLevelItem {
  final String name;
  final int value;

  AccessLevelItem({
    required this.name,
    required this.value,
  });
}

class AddMembersScreen extends GetView<AddMembersController> {
  const AddMembersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => _buildWidget(context));
  }

  Widget _buildWidget(context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add members"),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(context: context, delegate: DataSearch(controller));
            },
            tooltip: 'Search',
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.all(15), child: _formWidget(context)),
      floatingActionButton: AbsorbPointer(
        absorbing: controller.addedUsers.isEmpty,
        child: FloatingActionButton(
          onPressed: () {
            controller.onSubmit();
          },
          tooltip: 'Add',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _formWidget(context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          _sectionHeader('Members'),
          CardListItem(
            child: Column(
              children: [
                if (controller.addedUsers.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(24.0),
                    child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Tapping on the search icon will open up the member search box. You can add one or more members here.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey, fontSize: 14, height: 1.4),
                        )),
                  )
                else
                  ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.addedUsers.length,
                      itemBuilder: (context, index) {
                        var item = controller.addedUsers[index];
                        return ListTile(
                          title: Text(item.name!, style: const TextStyle(fontWeight: FontWeight.w500)),
                          leading: ListAvatar(avatarUrl: item.avatarUrl!),
                          trailing: IconButton(
                            onPressed: () {
                              controller.onItemRemove(item);
                            },
                            icon: const Icon(Icons.remove_circle_outline,
                                color: Colors.red),
                          ),
                        );
                      }),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _sectionHeader('Permission Level'),
          CardListItem(
            child: ListTile(
              title: const Text('Access level'),
              trailing: DropdownButton<AccessLevelItem>(
                  underline: Container(),
                  items: controller.accessLevels.map((e) {
                    return DropdownMenuItem<AccessLevelItem>(
                        value: e, child: Text(e.name));
                  }).toList(),
                  value: controller.selectedAccessLevel.value,
                  onChanged: (value) {
                    controller.onAccessLevelChanged(value);
                  }),
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

class DataSearch extends SearchDelegate<String> {
  late final AddMembersController controller;

  DataSearch(this.controller)
      : super(
          searchFieldStyle: const TextStyle(color: Colors.grey),
          searchFieldLabel: 'Search',
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
    controller.onSearchTextChanged(query);
    return _listWidget(context, controller);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    controller.onSearchTextChanged(query);
    return _listWidget(context, controller);
  }
}

Widget _listWidget(BuildContext context, AddMembersController controller) {
  return Obx(
    () => HttpFutureBuilder(
        state: controller.state.value,
        child: ListView.builder(
            controller: controller.scrollController,
            itemCount: controller.users.length,
            itemBuilder: (context, index) {
              var item = controller.users[index];

              return ListTile(
                leading: ListAvatar(avatarUrl: item.avatarUrl!),
                title: Text(item.name!),
                subtitle: Text(item.username!),
                onTap: () {
                  controller.onItemAdd(item);
                  Get.back();
                },
              );
            })),
  );
}
