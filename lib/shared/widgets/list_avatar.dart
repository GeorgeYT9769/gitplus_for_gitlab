import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gitplus_for_gitlab/shared/data/secure_storage.dart';

class ListAvatar extends StatelessWidget {
  final String avatarUrl;

  const ListAvatar({super.key, required this.avatarUrl});

  @override
  Widget build(BuildContext context) {
    if (avatarUrl.isEmpty) {
      return const CircleAvatar(
        child: Icon(Icons.person),
      );
    }
    return CircleAvatar(
      backgroundColor: Colors.transparent,
      child: CachedNetworkImage(
        color: Colors.transparent,
        imageUrl: avatarUrl,
        placeholder: (context, url) => const CircularProgressIndicator(year2023: false,),
        httpHeaders: {'PRIVATE-TOKEN': Get.find<SecureStorage>().getToken()},
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            image: DecorationImage(image: imageProvider),
          ),
        ),
        errorWidget: (context, url, error) => Row(
          children: [
            Icon(Icons.error),
            Text(
                'Failed to load image.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                )
            ),
          ],
        ),
      ),
    );
  }
}
