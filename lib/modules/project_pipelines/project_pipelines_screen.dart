import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gitplus_for_gitlab/models/models.dart';
import 'package:gitplus_for_gitlab/modules/project_pipelines/project_pipelines.dart';
import 'package:gitplus_for_gitlab/shared/shared.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';

class PipelinesScreen extends GetView<PipelinesController> {
  const PipelinesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildWidget(context);
  }

  Widget _buildWidget(context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Pipelines"),
        ),
        body: _buildList(
            controller, controller.scrollController, controller.pipelines));
  }

  Widget _buildList(PipelinesController controller,
      ScrollController scrollController, List<Pipeline> items) {
    return Obx(
      () => RefreshIndicator(
        onRefresh: () => controller.list(),
        child: HttpFutureBuilder(
          state: controller.state.value,
          child: Scrollbar(
            controller: scrollController,
            child: ListView.builder(
                controller: scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  var item = items[index];
                  return PipelineListItem(controller, item);
                }),
          ),
        ),
      ),
    );
  }
}

class PipelineListItem extends StatelessWidget {
  final PipelinesController controller;
  final Pipeline item;

  const PipelineListItem(this.controller, this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    Widget stateIcon =
        const Icon(Icons.question_mark_outlined, color: Colors.yellow);
    switch (item.status) {
      case 'success':
        stateIcon =
            const Icon(Icons.check_circle_outline, color: Colors.green);
        break;
      case 'failed':
        stateIcon = const Icon(Icons.error_outline, color: Colors.red);
        break;
      case 'canceled':
      case 'skipped':
        stateIcon =
            const Icon(Icons.do_not_disturb_on_outlined, color: Colors.grey);
        break;
      case 'scheduled':
      case 'pending':
      case 'waiting_for_resource':
      case 'preparing':
        stateIcon = const Icon(Icons.schedule, color: Colors.yellow);
        break;
      case 'running':
        stateIcon = const Icon(Icons.sync, color: Colors.blue);
        break;
      default:
        stateIcon =
            const Icon(Icons.question_mark_outlined, color: Colors.yellow);
        break;
    }

    Widget? trailingAction;
    if (item.status == 'running' || item.status == 'pending') {
      trailingAction = IconButton(
        icon: const Icon(Icons.cancel_outlined, color: Colors.red),
        tooltip: 'Cancel Pipeline',
        onPressed: () => controller.cancelPipeline(item.id!),
      );
    } else if (item.status == 'failed' || item.status == 'canceled' || item.status == 'success') {
      trailingAction = IconButton(
        icon: const Icon(Icons.refresh_outlined, color: Colors.blue),
        tooltip: 'Retry Pipeline',
        onPressed: () => controller.retryPipeline(item.id!),
      );
    }

    return CardListItem(
      child: ListTile(
        contentPadding: CommonConstants.contentPaddingLitTileLarge,
        title: Text(
          '#${item.iid} ${item.name ?? ""}',
          style:
              const TextStyle(fontWeight: CommonConstants.fontWeightListTile),
        ),
        leading: stateIcon,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (trailingAction != null) trailingAction,
            const Icon(Icons.keyboard_arrow_right),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(TextSpan(
              children: [
                TextSpan(
                    text: item.ref!,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold)),
                TextSpan(
                    text: " scheduled ${timeago.format(item.createdAt!)}",
                    style: const TextStyle(fontSize: 14)),
              ],
            )),
            const SizedBox(height: 5),
          ],
        ),
        onTap: () {
          launchUrl(Uri.parse(item.webUrl!));
        },
      ),
    );
  }
}