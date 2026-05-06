import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:gitplus_for_gitlab/models/models.dart';
import 'package:gitplus_for_gitlab/routes/app_pages.dart';
import 'package:gitplus_for_gitlab/shared/shared.dart';

enum AppDrawerItems { dashboard, projects, groups }

class AppDrawer extends StatelessWidget {
  final AppDrawerItems? selected;
  final AppAccount account;
  final Repository repository;

  const AppDrawer({
    super.key,
    this.selected,
    required this.account,
    required this.repository,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Scrollbar(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SafeArea(
              bottom: false,
              child: CardListItem(
                margin: const EdgeInsets.fromLTRB(12, 12, 12, 10),
                child: InkWell(
                  onTap: () {
                    Get.back();
                    Get.toNamed(Routes.accounts);
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          maxRadius: 30,
                          backgroundColor: Colors.transparent,
                          child: CachedNetworkImage(
                            imageUrl: account.avatarUrl ?? "",
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                image: DecorationImage(image: imageProvider),
                              ),
                            ),
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(
                              year2023: false,
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.person),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(account.name ?? "",
                                  style: const TextStyle(
                                      fontSize: 18, fontWeight: FontWeight.bold)),
                              Text(account.username ?? "",
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant)),
                            ],
                          ),
                        ),
                        const Icon(Icons.keyboard_arrow_right),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            DrawerListTile(
                title: "Overview",
                icon: FontAwesome.gitlab,
                selected: selected == AppDrawerItems.dashboard,
                onTap: () {
                  Get.back();
                  Get.offNamed(Routes.home);
                }),
            DrawerListTile(
                title: "Projects",
                icon: MaterialCommunityIcons.git,
                selected: selected == AppDrawerItems.projects,
                onTap: () {
                  Get.back();
                  Get.offNamed(Routes.projects);
                }),
            DrawerListTile(
                title: "Groups",
                icon: Octicons.file_submodule,
                selected: selected == AppDrawerItems.groups,
                onTap: () {
                  Get.back();
                  Get.offNamed(Routes.groups);
                }),
            DrawerListTile(
                title: "Settings",
                icon: Icons.settings,
                onTap: () {
                  Get.back();
                  Get.toNamed(Routes.settings);
                }),
            DrawerListTile(
                title: "Help & Feedback",
                icon: Octicons.info,
                onTap: () {
                  Get.back();
                  Get.toNamed(Routes.about);
                }),
            DrawerListTile(
                title: "Logout",
                icon: Icons.logout,
                onTap: () async {
                  showDialog(
                    context: context,
                    builder: (context) => QuestionMessagePresetsDialog(
                      title: 'Logout',
                      text: 'Are you sure?',
                      action: () async {
                        Get.back();
                        var sstorage = Get.find<SecureStorage>();
                        await sstorage.removeAccount(account);
                        if (sstorage.getAccounts().isEmpty) {
                          Get.offAllNamed(Routes.auth);
                        } else {
                          var newacc = sstorage.getAccounts()[0];
                          await sstorage
                              .setDefaultAccount(sstorage.getAccounts()[0]);
                          repository.account.value = AppAccount.fromJson(
                              sstorage.getDefaultAccount().toJson());
                          CommonWidget.toast(
                              "Account switched to ${newacc.name!}");
                        }
                      },
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
