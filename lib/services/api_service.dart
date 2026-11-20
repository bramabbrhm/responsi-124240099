import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/book_model.dart';
import '../models/spell_model.dart';

class ApiService {
  static const String baseUrl = 'https://potterapi-fedeperin.vercel.app/en';

  Future<List<BookModel>> fetchBooks() async {
    final response = await http.get(Uri.parse('$baseUrl/books'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data
          .map((item) => BookModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load books: ${response.statusCode}');
    }
  }

  Future<BookModel> fetchBookDetail(int index) async {
    final response = await http.get(Uri.parse('$baseUrl/books?index=$index'));
    if (response.statusCode == 200) {
      final dynamic data = json.decode(response.body);
      if (data is List) {
        if (data.isNotEmpty) {
          return BookModel.fromJson(data.first as Map<String, dynamic>);
        } else {
          throw Exception('Book not found');
        }
      } else if (data is Map<String, dynamic>) {
        return BookModel.fromJson(data);
      } else {
        throw Exception('Invalid response format');
      }
    } else {
      throw Exception('Failed to load book detail: ${response.statusCode}');
    }
  }

  Future<List<SpellModel>> fetchSpells() async {
    final response = await http.get(Uri.parse('$baseUrl/spells'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data
          .map((item) => SpellModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load spells: ${response.statusCode}');
    }
  }
}
