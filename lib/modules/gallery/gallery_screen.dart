import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:pix_gallery/modules/gallery/gallery_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';

class GalleryScreen extends GetView<GalleryController> {
  const GalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(()=>Scaffold(
      floatingActionButton: controller.showFab.value ? FloatingActionButton(
        backgroundColor: Colors.black,
        child: const Icon(Icons.arrow_upward_rounded, color: Colors.white,),
        onPressed: (){
          controller.scrollController.animateTo(
            0, // Scroll to the top
            duration: const Duration(milliseconds: 300), // Animation duration
            curve: Curves.easeInOut, // Animation curve
          );
        },
      ):null,
      appBar: AppBar(
        elevation: 10,
        backgroundColor: Colors.black,
        title: Text('Pixabay Gallery', style: Get.textTheme.titleSmall!.copyWith(color: Colors.white),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: LayoutBuilder(
          builder: (context, constraint) {
            controller.updateColumns(constraint);
            return SizedBox(
              height: constraint.maxHeight,
              child: Obx(
                    () {
                  if (controller.isLoading.value && controller.items.isEmpty) {
                    return const Center(child: CupertinoActivityIndicator());
                  }

                  return MasonryGridView.count(
                    controller: controller.scrollController,
                    crossAxisCount: controller.columns.value-1,
                    // Set your number of columns here
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    itemCount: controller.items.length + 1,
                    // Add 1 for the loading indicator
                    itemBuilder: (context, index) {
                      if (index == controller.items.length) {
                        // Loading indicator at the end of the list
                        return const SizedBox.shrink(); // Empty box when not loading
                      }

                      final Map<String, dynamic> imageItem = controller.items[index];

                      return Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CachedNetworkImage(
                              imageUrl: imageItem['webformatURL'],
                              fit: BoxFit.cover,
                              errorWidget: (context, url, error) => const Icon(Icons.error),
                            ),
                          ),
                          Positioned(
                            right: 16,
                            bottom: 16,
                            child: Row(
                              children: [
                                /* ,,*/
                                Container(
                                  height: 20,
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: Colors.black26,
                                      borderRadius: BorderRadius.circular(12)
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.favorite, color: Colors.white, size: 12,),
                                      const SizedBox(width: 5),
                                      Text(
                                        formatNumber(imageItem['likes']),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),

                                ),
                                const SizedBox(width: 12,),
                                Container(
                                  height: 20,
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: Colors.black26,
                                      borderRadius: BorderRadius.circular(12)
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.remove_red_eye_rounded, color: Colors.white, size: 12,),
                                      const SizedBox(width: 5),
                                      Text(
                                        formatNumber(imageItem['views']),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),

                                )
                              ],
                            ),
                          )
                        ],
                      );
                    },
                  );
                },
              ),
            );
          },
        ),
      ),
    ));
  }
  String formatNumber(int number) {
    if (number < 1000) {
      return number.toString(); // Return as-is if less than 1000
    } else if (number < 1000000) {
      // For thousands
      return '${(number / 1000).toStringAsFixed(1)}k'; // One decimal place
    } else {
      // For millions
      return '${(number / 1000000).toStringAsFixed(1)}M'; // One decimal place
    }
  }
}
