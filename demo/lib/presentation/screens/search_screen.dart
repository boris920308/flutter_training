import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Riverpod 임포트
import '../../domain/entities/book.dart';
import '../providers/book_provider.dart'; // 생성한 Provider 임포트

// 1. ConsumerWidget으로 변경하여 Provider에 접근합니다.
class BookSearchScreen extends ConsumerWidget {
  const BookSearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 2. Provider로부터 실시간 검색 결과 상태를 읽어옵니다.
    final bookAsync = ref.watch(bookListProvider);

    final screenWidth = MediaQuery.of(context).size.width;
    final isWeb = screenWidth > 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('네이버 도서 검색'),
        elevation: 0,
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: isWeb ? 800 : double.infinity),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // 3. 검색창 위젯 (ref를 넘겨줌)
              _buildSearchBar(ref),
              const SizedBox(height: 20),

              // 4. API 상태(로딩, 에러, 데이터)에 따른 화면 처리
              Expanded(
                child: bookAsync.when(
                  // 데이터 로드 성공 시
                  data: (books) => books.isEmpty
                      ? const Center(child: Text('검색 결과가 없습니다.'))
                      : ListView.separated(
                    itemCount: books.length,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) => _buildBookTile(books[index]),
                  ),
                  // 로딩 중일 때
                  loading: () => const Center(child: CircularProgressIndicator()),
                  // 에러 발생 시
                  error: (err, stack) => Center(child: Text('에러 발생: $err')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 검색바: 엔터를 치면 searchQueryProvider의 상태를 업데이트합니다.
  Widget _buildSearchBar(WidgetRef ref) {
    return TextField(
      decoration: InputDecoration(
        hintText: '책 제목, 저자명을 입력하세요',
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey[100],
      ),
      onSubmitted: (value) {
        // 검색어 상태를 변경하면 bookListProvider가 자동으로 API를 다시 호출합니다.
        ref.read(searchQueryProvider.notifier).state = value;
      },
    );
  }

  // 도서 아이템: MockBook 대신 실제 Book 엔티티를 사용합니다.
  Widget _buildBookTile(Book book) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              book.image,
              width: 80,
              height: 110,
              fit: BoxFit.cover,
              // 이전과 동일한 로딩/에러 처리 로직
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  width: 80, height: 110, color: Colors.grey[200],
                  child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 80, height: 110, color: Colors.grey[300],
                  alignment: Alignment.center,
                  child: const Icon(Icons.broken_image, color: Colors.grey),
                );
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  book.title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(book.author, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                const SizedBox(height: 8),
                Text(
                  book.description,
                  style: const TextStyle(fontSize: 13),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}