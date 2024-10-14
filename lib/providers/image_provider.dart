import 'dart:convert';
import 'package:http/http.dart' as http;

class GalleryProvider {
  /// Below key should be saved in safe sandbox but this is just for testing
  static const String _pixaBayApiKey = '41757688-c4029d3e8f80c901f73c2849c';

  static const String _apiUrl =
      'https://pixabay.com/api/?key=$_pixaBayApiKey&image_type=photo';

  Future<List<Map<String, dynamic>>> fetchImages(int pageKey) async {
    final response = await http.get(Uri.parse('$_apiUrl&page=$pageKey'));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
   
      final List<Map<String, dynamic>> newItems = 
          List<Map<String, dynamic>>.from(jsonData['hits']);
      return newItems;
    } else {
      throw Exception('Failed to fetch images');
    }
  }
}
