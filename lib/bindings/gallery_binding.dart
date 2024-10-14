import 'package:get/get.dart';
import 'package:pix_gallery/modules/gallery/gallery_controller.dart';
import 'package:pix_gallery/providers/image_provider.dart';

class GalleryBinding extends Bindings{
  @override
  void dependencies() {
    Get.put(GalleryProvider());
    Get.put(GalleryController());
  }
  /// Nothing to explain just injecting dependencies
}