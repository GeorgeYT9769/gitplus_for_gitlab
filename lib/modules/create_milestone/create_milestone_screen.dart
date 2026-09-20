import 'package:flutter/material.dart';
import 'package:gitplus_for_gitlab/shared/shared.dart';

import 'package:get/get.dart';

import 'create_milestone.dart';

class CreateMilestoneScreen extends GetView<CreateMilestoneController> {
  const CreateMilestoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildWidget(context);
  }

  Widget _buildWidget(context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add milestone'.tr),
      ),
      body: SafeArea(bottom: false, child: _buildForm(context)),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.addProjectMilestone();
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
          _sectionHeader('Milestone Information'),
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
                  DateTimeField(
                    controller: controller.dueDateController,
                    labelText: 'Due date'.tr,
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
