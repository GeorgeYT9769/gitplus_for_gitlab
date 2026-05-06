import 'package:flutter/material.dart';
import 'package:gitplus_for_gitlab/models/models.dart';
import 'package:gitplus_for_gitlab/shared/shared.dart';
import 'package:intl/intl.dart';

import 'package:get/get.dart';

import 'milestone.dart';

enum MilestoneScreenPopupActions { edit, close, reopen, delete }

class MilestoneScreen extends GetView<MilestoneController> {
  const MilestoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => _buildWidget(context));
  }

  Widget _buildWidget(context) {
    var item = controller.repository.milestone.value;
    return Scaffold(
      appBar: AppBar(
        title: Text(item.title ?? ''),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) =>
                <PopupMenuEntry<MilestoneScreenPopupActions>>[
              PopupMenuItem(
                  value: MilestoneScreenPopupActions.edit,
                  child: Text('Edit'.tr)),
              item.state == MilestoneState.active
                  ? PopupMenuItem(
                      value: MilestoneScreenPopupActions.close,
                      child: Text('Close'.tr))
                  : PopupMenuItem(
                      value: MilestoneScreenPopupActions.reopen,
                      child: Text('Reopen'.tr)),
              const PopupMenuDivider(),
              PopupMenuItem(
                  value: MilestoneScreenPopupActions.delete,
                  child: Text(
                    'Delete'.tr,
                    style: const TextStyle(color: Colors.red),
                  )),
            ],
            onSelected: (MilestoneScreenPopupActions value) =>
                controller.onPopupSelected(value, context),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => controller.onRefresh(),
        child: SafeArea(
          bottom: false,
          child: Scrollbar(
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CardListItem(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// state
                            Row(
                              children: [
                                MilestoneStateLabel(item: item),
                                const SizedBox(width: 12),
                                if (item.startDate != null)
                                  Flexible(
                                      child: Text(
                                    DateFormat('MMM dd, yyyy - ')
                                        .format(item.startDate!),
                                    style: const TextStyle(fontSize: 14),
                                  )),
                                if (item.dueDate != null)
                                  Flexible(
                                      child: Text(
                                    DateFormat('MMM dd, yyyy')
                                        .format(item.dueDate!),
                                    style: const TextStyle(fontSize: 14),
                                  )),
                              ],
                            ),
    
                            /// completion
    
                            const SizedBox(height: 16),
                            LinearProgressIndicator(
                                value: controller.completePercProgress.value,
                                borderRadius: BorderRadius.circular(4),
                                minHeight: 8,
                                color: controller.completePercProgress.value == 1
                                    ? Colors.green
                                    : null),
                            const SizedBox(height: 8),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text.rich(
                                    TextSpan(
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurfaceVariant,
                                          fontSize: 13),
                                      children: [
                                        TextSpan(
                                            text: controller.issues.length
                                                .toString()),
                                        if (controller.issues.length == 1)
                                          const TextSpan(text: ' Issue, ')
                                        else
                                          const TextSpan(text: ' Issues, '),
                                        TextSpan(
                                            text:
                                                controller.mr.length.toString()),
                                        if (controller.mr.length == 1)
                                          const TextSpan(text: ' Merge request')
                                        else
                                          const TextSpan(text: ' Merge requests')
                                      ],
                                    ),
                                  ),
                                ),
                                Text('${controller.completePerc.string}% complete',
                                    style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
    
                            /// description
    
                            if (item.description != null &&
                                item.description!.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 16.0),
                                child: Text(item.description!,
                                    style: const TextStyle(fontSize: 14)),
                              ),
                          ],
                        ),
                      ),
                    ),
                    if (controller.issues.isNotEmpty) _issues(),
                    if (controller.mr.isNotEmpty) _mr(),
                    const SizedBox(height: 16),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _headerLabel(String text) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        text,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _issues() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _headerLabel('Related issues'.tr),
        for (var item in controller.issues) _issueListItem(item)
      ],
    );
  }

  Widget _issueListItem(Issue item) {
    return CardListItem(
      padding: EdgeInsets.zero,
      child: ListTile(
        leading: ListAvatar(avatarUrl: item.author!.avatarUrl!),
        trailing: const Icon(Icons.keyboard_arrow_right),
        title: Text(item.title!),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            _issueStateWidget(item),
          ],
        ),
        onTap: () {
          controller.navigateToIssue(item);
        },
      ),
    );
  }

  Widget _mr() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _headerLabel('Related merge requests'.tr),
        for (var item in controller.mr) _mrListItem(item)
      ],
    );
  }

  Widget _mrListItem(MergeRequest item) {
    return CardListItem(
      padding: EdgeInsets.zero,
      child: ListTile(
        leading: ListAvatar(avatarUrl: item.author!.avatarUrl!),
        trailing: const Icon(Icons.keyboard_arrow_right),
        title: Text(item.title!),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            _mrStateWidget(item),
          ],
        ),
        onTap: () {
          controller.navigateToMr(item);
        },
      ),
    );
  }
}

Widget _issueStateWidget(Issue item) {
  return ColorLabel(
    color: item.state == IssueState.opened ? Colors.green : Colors.red,
    text: item.state == IssueState.opened ? "Open".tr : "Closed".tr,
    fontSize: 12,
  );
}

Widget _mrStateWidget(MergeRequest item) {
  return ColorLabel(
    color: item.state == MergeRequestState.opened ? Colors.green : Colors.red,
    text: item.state == MergeRequestState.opened ? "Open".tr : "Closed".tr,
    fontSize: 12,
  );
}
