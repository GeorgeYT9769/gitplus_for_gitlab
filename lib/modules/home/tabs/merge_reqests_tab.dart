import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gitplus_for_gitlab/models/models.dart';
import 'package:gitplus_for_gitlab/modules/home/home.dart';
import 'package:gitplus_for_gitlab/shared/shared.dart';
import 'package:timeago/timeago.dart' as timeago;

class MergeRequestsTab extends GetView<HomeController> {
  const MergeRequestsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => _buildList(controller, controller.mergeRequests));
  }
}

Widget _buildList(HomeController controller, List<MergeRequest> items) {
    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Row(
            children: [
              FilterChip(
                label: const Text('All States'),
                selected: controller.mergeRequestsFilterState.value.isEmpty,
                onSelected: (_) => controller.onMergeRequestStateChanged(''),
              ),
              const SizedBox(width: 6),
              FilterChip(
                label: const Text('Open'),
                selected: controller.mergeRequestsFilterState.value == MergeRequestState.opened,
                onSelected: (_) => controller.onMergeRequestStateChanged(MergeRequestState.opened),
              ),
              const SizedBox(width: 6),
              FilterChip(
                label: const Text('Closed'),
                selected: controller.mergeRequestsFilterState.value == MergeRequestState.closed,
                onSelected: (_) => controller.onMergeRequestStateChanged(MergeRequestState.closed),
              ),
              const SizedBox(width: 6),
              FilterChip(
                label: const Text('Merged'),
                selected: controller.mergeRequestsFilterState.value == MergeRequestState.merged,
                onSelected: (_) => controller.onMergeRequestStateChanged(MergeRequestState.merged),
              ),
              const SizedBox(width: 8),
              Container(width: 1, height: 20, color: Colors.grey.withAlpha(100)),
              const SizedBox(width: 8),
              FilterChip(
                label: const Text('All Scopes'),
                selected: controller.mergeRequestsFilterScope.value == MergeRequestScope.all,
                onSelected: (_) => controller.onMergeRequestScopeChanged(MergeRequestScope.all),
              ),
              const SizedBox(width: 6),
              FilterChip(
                label: const Text('Created'),
                selected: controller.mergeRequestsFilterScope.value == MergeRequestScope.createdByMe,
                onSelected: (_) => controller.onMergeRequestScopeChanged(MergeRequestScope.createdByMe),
              ),
              const SizedBox(width: 6),
              FilterChip(
                label: const Text('Assigned'),
                selected: controller.mergeRequestsFilterScope.value == MergeRequestScope.assignedToMe,
                onSelected: (_) => controller.onMergeRequestScopeChanged(MergeRequestScope.assignedToMe),
              ),
            ],
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () => controller.listMergeRequests(),
            child: HttpFutureBuilder(
              state: controller.mrState.value,
              emptyWidget: const EmptyWidget(
                title: 'No Merge Requests Found',
                message: 'All open, closed, or integrated changes are monitored here.',
                icon: Icons.merge_type_outlined,
              ),
              child: Scrollbar(
                controller: controller.mrScrollController,
                child: ListView.builder(
                    controller: controller.mrScrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      var item = items[index];
                      return _buildListItem(controller, item, context);
                    }),
              ),
            ),
          ),
        ),
      ],
    );
}

Widget _buildListItem(
    HomeController controller, MergeRequest item, BuildContext context) {
  return CardListItem(
    child: ListTile(
      contentPadding: CommonConstants.contentPaddingLitTileLarge,
      leading: ListAvatar(avatarUrl: item.author!.avatarUrl!),
      title: Text(
        item.title!,
        style:
            const TextStyle(fontWeight: CommonConstants.fontWeightListTile),
      ),
      trailing: const Icon(Icons.keyboard_arrow_right),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                    text: "${item.author!.name!} ",
                    style: const TextStyle(
                        fontWeight: CommonConstants.fontWeightListTile)),
                TextSpan(
                    text: "authored ${timeago.format(item.createdAt!)}",
                    style: const TextStyle(fontSize: 14)),
              ],
            ),
          ),
          const SizedBox(height: 5),
          _stateWidget(item),
        ],
      ),
      onTap: () {
        controller.onNavToMergeRequestDetails(item);
      },
    ),
  );
}

Widget _stateWidget(MergeRequest item) {

  switch(item.state) {
    case MergeRequestState.opened:
      return ColorLabel(color: Colors.green, text: "Open".tr);
    case MergeRequestState.closed:
      return ColorLabel(color: Colors.red, text: "Closed".tr);
    case MergeRequestState.locked:
      return ColorLabel(color: Colors.yellow, text: "Locked".tr);
    case MergeRequestState.merged:
      return ColorLabel(color: Colors.purple, text: "Merged".tr);
  }

  return ColorLabel(color: Colors.white, text: "Unknown".tr);
}