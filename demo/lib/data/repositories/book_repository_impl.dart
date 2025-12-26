import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../domain/entities/book.dart';
import '../../domain/repositories/book_repository.dart';

class BookRepositoryImpl implements BookRepository {
  final Dio _dio;
  final String _clientId = dotenv.env['NAVER_CLIENT_ID'] ?? '';
  final String _clientSecret = dotenv.env['NAVER_CLIENT_SECRET'] ?? '';

  BookRepositoryImpl(this._dio);

  @override
  Future<List<Book>> searchBooks(String query) async {
    if (query.isEmpty) return [];

    final response = await _dio.get(
      'https://openapi.naver.com/v1/search/book.json',
      queryParameters: {'query': query, 'display': 20},
      options: Options(headers: {
        'X-Naver-Client-Id': _clientId,
        'X-Naver-Client-Secret': _clientSecret,
      }),
    );

    final List items = response.data['items'];
    return items.map((json) => Book.fromJson(json)).toList();
  }
}