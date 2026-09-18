import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:gitplus_for_gitlab/models/models.dart';
import 'package:gitplus_for_gitlab/modules/home/home.dart';
import 'package:gitplus_for_gitlab/shared/shared.dart';
import 'package:timeago/timeago.dart' as timeago;

class IssuesTab extends GetView<HomeController> {
  const IssuesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => _buildList());
  }

  Widget _buildList() {
    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Row(
            children: [
              FilterChip(
                label: const Text('All States'),
                selected: controller.issuesFilterState.value.isEmpty,
                onSelected: (_) => controller.onIssuesStateChanged(''),
              ),
              const SizedBox(width: 6),
              FilterChip(
                label: const Text('Open'),
                selected: controller.issuesFilterState.value == IssueState.opened,
                onSelected: (_) => controller.onIssuesStateChanged(IssueState.opened),
              ),
              const SizedBox(width: 6),
              FilterChip(
                label: const Text('Closed'),
                selected: controller.issuesFilterState.value == IssueState.closed,
                onSelected: (_) => controller.onIssuesStateChanged(IssueState.closed),
              ),
              const SizedBox(width: 8),
              Container(width: 1, height: 20, color: Colors.grey.withAlpha(100)),
              const SizedBox(width: 8),
              FilterChip(
                label: const Text('All Scopes'),
                selected: controller.issuesFilterScope.value == IssuesScope.all,
                onSelected: (_) => controller.onIssuesScopeChanged(IssuesScope.all),
              ),
              const SizedBox(width: 6),
              FilterChip(
                label: const Text('Created'),
                selected: controller.issuesFilterScope.value == IssuesScope.createdByMe,
                onSelected: (_) => controller.onIssuesScopeChanged(IssuesScope.createdByMe),
              ),
              const SizedBox(width: 6),
              FilterChip(
                label: const Text('Assigned'),
                selected: controller.issuesFilterScope.value == IssuesScope.assignedToMe,
                onSelected: (_) => controller.onIssuesScopeChanged(IssuesScope.assignedToMe),
              ),
            ],
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () => controller.listIssues(),
            child: HttpFutureBuilder(
              state: controller.issuesState.value,
              child: Scrollbar(
                controller: controller.issuesScrollController,
                child: ListView.builder(
                    controller: controller.issuesScrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: controller.issues.length,
                    itemBuilder: (context, index) {
                      var item = controller.issues[index];
                      return _buildListItem(item, context);
                    }),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildListItem(Issue item, BuildContext context) {
    return CardListItem(
      child: ListTile(
        contentPadding: CommonConstants.contentPaddingLitTileLarge,
        leading: ListAvatar(avatarUrl: item.author!.avatarUrl!),
        title: Text(
          '#${item.iid} ${item.title!}',
          style:
              const TextStyle(fontWeight: CommonConstants.fontWeightListTile),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(TextSpan(
              children: [
                TextSpan(
                    text: item.author!.name,
                    style: const TextStyle(fontSize: 14)),
                TextSpan(
                    text: ", authored ${timeago.format(item.createdAt!)}",
                    style: const TextStyle(fontSize: 14)),
              ],
            )),
            const SizedBox(height: 5),
            Row(
              children: [
                _stateWidget(item),

                const SizedBox(width: 15),

                /// mr
                const Icon(Octicons.git_merge, size: 18),
                const SizedBox(width: 3),
                Text(item.mergeRequestsCount.toString(),
                    style: const TextStyle(fontSize: 12)),

                const SizedBox(width: 10),

                /// comments
                const Icon(Octicons.comment_discussion, size: 18),
                const SizedBox(width: 5),
                Text(item.userNotesCount.toString(),
                    style: const TextStyle(fontSize: 12)),
              ],
            ),
          ],
        ),
        trailing: const Icon(Icons.keyboard_arrow_right),
        onTap: () {
          controller.onNavToIssueDetails(item);
        },
      ),
    );
  }
}

Widget _stateWidget(Issue item) {
  return ColorLabel(
    color: item.state == IssueState.opened ? Colors.green : Colors.red,
    text: item.state == IssueState.opened ? "Open".tr : "Closed".tr,
    fontSize: 12,
  );
}
