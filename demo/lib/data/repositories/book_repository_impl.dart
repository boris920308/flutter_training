import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../domain/entities/book.dart';
import '../../domain/repositories/book_repository.dart';

class BookRepositoryImpl implements BookRepository {
  final Dio _dio;

  final String _supabaseUrl = 'https://jwradhdlfjgbmdwdwful.supabase.co';
  final String _anonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imp3cmFkaGRsZmpnYm1kd2R3ZnVsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjY3MjAyMzYsImV4cCI6MjA4MjI5NjIzNn0.BCnvQIiMGYJBd4EKQqeDMI_OerrtDroqK5vDH2hLSTg';

  BookRepositoryImpl(this._dio);

  @override
  Future<List<Book>> searchBooks(String query) async {
    if (query.isEmpty) return [];

    try {
      // 2. Supabase Edge Function 호출 주소 설정
      // 형식: {프로젝트URL}/functions/v1/{함수이름}
      final String functionUrl = '$_supabaseUrl/functions/v1/naver-search';

      // 3. Dio를 이용한 POST 요청
      final response = await _dio.post(
        functionUrl,
        data: {'query': query}, // Edge Function 내부의 req.json()으로 전달될 데이터
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            // 중요: Supabase 인증을 위해 Bearer 토큰 형식으로 anonKey를 보냅니다.
            'Authorization': 'Bearer $_anonKey',
          },
        ),
      );

      // 4. 응답 데이터 처리
      // response.data는 이미 JSON 파싱된 Map 형태입니다.
      final List items = response.data['items'];
      return items.map((json) => Book.fromJson(json)).toList();

    } on DioException catch (e) {
      // 에러 핸들링
      print('Supabase 호출 에러: ${e.message}');
      if (e.response != null) {
        print('에러 상세: ${e.response?.data}');
      }
      return [];
    }
  }
}