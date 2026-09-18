import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

import 'package:get/get.dart';
import 'package:gitplus_for_gitlab/shared/shared.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:gitplus_for_gitlab/shared/utils/legal_texts.dart';
import 'about.dart';

class AboutScreen extends GetView<AboutController> {
  const AboutScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return Obx(() => _buildWidget(context));
  }

  Widget _buildWidget(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CrossFade<String>(
          initialData: '',
          data: 'Help & Feedback',
          builder: (value) => Text(value),
        ),
      ),
      body: SafeArea(bottom: false, child: _buildContent(context)),
    );
  }

  Widget _buildContent(BuildContext context) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        const SizedBox(height: 20),
        // App Header Section
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(20),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: SvgPicture.asset(
                    "././assets/logo/2.svg",
                    width: 100,
                    height: 100,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Git+ for GitLab',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 6),
              // Wrapper to give chip look
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  color: Get.theme.colorScheme.primaryContainer.withAlpha(76),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: Text(
                    'v${controller.version.value}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Get.theme.colorScheme.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Forked by GeorgeYT9769',
                style: TextStyle(
                  fontSize: 14,
                  color: Get.theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 35),
        
        // Settings / Actions Group
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Developer & Community',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Get.theme.colorScheme.primary,
              letterSpacing: 0.5,
            ),
          ),
        ),
        const SizedBox(height: 10),
        
        CardListItem(
          child: ListTile(
            leading: Icon(Octicons.mark_github, color: Get.theme.colorScheme.onSurface),
            title: const Text(
              'Visit GitHub Repository',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            subtitle: const Text('View source code, report issues or contribute'),
            trailing: const Icon(Icons.chevron_right, size: 20),
            onTap: () {
              launchUrl(Uri.parse('https://github.com/GeorgeYT9769/gitplus_for_gitlab'),
                  mode: LaunchMode.externalApplication);
            },
          ),
        ),
        
        CardListItem(
          child: ListTile(
            leading: Icon(Icons.bug_report_outlined, color: Get.theme.colorScheme.error),
            title: const Text(
              'Report an Issue',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            subtitle: const Text('Submit bugs or feature requests on GitHub'),
            trailing: const Icon(Icons.chevron_right, size: 20),
            onTap: () {
              launchUrl(Uri.parse('https://github.com/GeorgeYT9769/gitplus_for_gitlab/issues'),
                  mode: LaunchMode.externalApplication);
            },
          ),
        ),

        const SizedBox(height: 25),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Legal & Information',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Get.theme.colorScheme.primary,
              letterSpacing: 0.5,
            ),
          ),
        ),
        const SizedBox(height: 10),

        CardListItem(
          child: ListTile(
            leading: Icon(Icons.privacy_tip_outlined, color: Get.theme.colorScheme.primary),
            title: const Text('Privacy Policy', style: TextStyle(fontWeight: FontWeight.w500)),
            trailing: const Icon(Icons.chevron_right, size: 20),
            onTap: () => _showLegalDialog(context, 'Privacy Policy', LegalTexts.privacyPolicy),
          ),
        ),

        CardListItem(
          child: ListTile(
            leading: Icon(Icons.description_outlined, color: Get.theme.colorScheme.primary),
            title: const Text('Terms of Service', style: TextStyle(fontWeight: FontWeight.w500)),
            trailing: const Icon(Icons.chevron_right, size: 20),
            onTap: () => _showLegalDialog(context, 'Terms of Service', LegalTexts.termsOfService),
          ),
        ),
        
        const SizedBox(height: 25),
        
        // Footer Credits
        Center(
          child: Text(
            'Made with ❤️ for the GitLab Community',
            style: TextStyle(
              fontSize: 12,
              color: Get.theme.colorScheme.onSurfaceVariant.withAlpha(178),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  void _showLegalDialog(BuildContext context, String title, String text) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: Text(text, style: const TextStyle(fontSize: 14, height: 1.4)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
