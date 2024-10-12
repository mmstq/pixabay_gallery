import 'package:get/get.dart';
import 'package:pix_gallery/bindings/gallery_binding.dart';
import 'package:pix_gallery/modules/gallery/gallery_screen.dart';
import 'package:pix_gallery/routes/routes.dart';

class AppPages {
  static const initial = Routes.gallery;

  static final routes = [
    GetPage(
      name: Routes.gallery,
      page: () => const GalleryScreen(),
      binding: GalleryBinding(),
    )
  ];
}