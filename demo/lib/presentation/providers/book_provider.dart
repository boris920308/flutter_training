// presentation/providers/book_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../data/repositories/book_repository_impl.dart';
import '../../domain/repositories/book_repository.dart';
import '../../domain/entities/book.dart';

// 1. Repository 인터페이스의 실제 구현체를 주입합니다.
final bookRepositoryProvider = Provider<BookRepository>((ref) {
  return BookRepositoryImpl(Dio());
});

// 2. 검색창의 텍스트 상태를 관리합니다.
final searchQueryProvider = StateProvider<String>((ref) => "");

// 3. 🌟 UI에서 사용할 도서 리스트 (검색어가 바뀔 때마다 자동 호출)
final bookListProvider = FutureProvider<List<Book>>((ref) async {
  final query = ref.watch(searchQueryProvider); // 검색어 관찰
  if (query.isEmpty) return [];

  final repository = ref.read(bookRepositoryProvider);
  return repository.searchBooks(query);
});