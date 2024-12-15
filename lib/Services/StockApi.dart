import 'dart:convert';
import 'package:http/http.dart' as http;

class StockApi {
  final String apiKey = 'ctdl8k1r01qng9gesss0ctdl8k1r01qng9gesssg'; // Replace with your actual Finnhub API key
  final String baseUrl = 'https://finnhub.io/api/v1';

  // Search stocks based on the query
  Future<List<Map<String, dynamic>>> searchStocks(String query) async {
    final url = '$baseUrl/search?q=$query&token=$apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data['result']);
    } else {
      throw Exception('Failed to load stocks');
    }
  }

  // Get stock details based on symbol
  Future<Map<String, dynamic>> getStockDetail(String symbol) async {
    final url = '$baseUrl/quote?symbol=$symbol&token=$apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data;
    } else {
      throw Exception('Failed to load stock details');
    }
  }

  // Fetch general market news
  Future<List<Map<String, String>>> fetchMarketNews() async {
    final url = '$baseUrl/news?category=general&token=$apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // Print the response body for debugging
      print('Response body: ${response.body}');
      
      final List<dynamic> data = json.decode(response.body);

      // Ensure the values inside the map are of type String
      return data.map((article) {
        return {
          'headline': article['headline']?.toString() ?? '', // Ensuring it's a String
          'summary': article['summary']?.toString() ?? '',   // Ensuring it's a String
          'url': article['url']?.toString() ?? '',           // Ensuring it's a String
        };
      }).toList();
    } else {
      throw Exception('Failed to load market news');
    }
  }
}
