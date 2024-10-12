import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pix_gallery/providers/image_provider.dart';

class GalleryController extends GetxController {
  final imageProvider = Get.find<GalleryProvider>();
  RxBool isLoading = false.obs;
  RxList<Map<String, dynamic>> items = <Map<String, dynamic>>[].obs;

  RxInt columns = 4.obs;
  Rxn<Map<String, dynamic>> selectedImage = Rxn<Map<String, dynamic>>();
  int _currentPage = 1;
  ScrollController scrollController = ScrollController();
  RxBool showFab = false.obs;




  @override
  void onInit() {
    fetchImages();
    // Listen to scroll events
    scrollController.addListener(() {
      if(scrollController.offset == 0){
        showFab.value = false;
      }else{
        showFab.value = true;
      }
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        fetchImages(); // Fetch more images when scrolled to the bottom
      }
    });
    super.onInit();
  }

  void a(){
  }


  Future<void> fetchImages() async {
    if (isLoading.value) return; // Prevent multiple simultaneous requests
    isLoading.value = true;

    // Fetch images for the current page
    List<Map<String, dynamic>> newItems = await imageProvider.fetchImages(_currentPage);
    items.addAll(newItems); // Append new items to the list

    _currentPage++; // Increment the page for the next fetch
    isLoading.value = false;
  }
  void selectImage(Map<String, dynamic> image) {
    selectedImage.value = image;
  }

  void clearSelectedImage() {
    selectedImage.value = null;
  }

  void updateColumns(BoxConstraints constraint) {
    // Define a mapping of screen width thresholds to column counts
    final Map<double, int> columnMapping = {
      1200: 6,
      800: 4,
      400: 3,
      0: 2, // Default columns for any width less than 400
    };

    // Find the appropriate column count based on the screen width
    columns.value = columnMapping.entries
        .where((entry) => constraint.maxWidth >= entry.key)
        .map((entry) => entry.value)
        .first; // Get the first matching column count
  }

}
