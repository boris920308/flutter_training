import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:ui_web' as ui_web; // 최신 Flutter 버전용
import 'dart:html' as html;
import '../../domain/entities/book.dart';
import '../providers/book_provider.dart';

class BookSearchScreen extends ConsumerWidget {
  const BookSearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookAsync = ref.watch(bookListProvider);
    final isWeb = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('네이버 도서 검색'),
        elevation: 0,
        centerTitle: true,
      ),
      body: SelectionArea(
        child: Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: isWeb ? 800 : double.infinity),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildSearchBar(ref),
                const SizedBox(height: 20),
                Expanded(
                  child: bookAsync.when(
                    data: (books) => books.isEmpty
                        ? const Center(child: Text('검색 결과가 없습니다.'))
                        : ListView.separated(
                      itemCount: books.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) => _buildBookTile(books[index]),
                    ),
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (err, stack) => Center(child: Text('에러 발생: $err')),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

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
        if (value.trim().isNotEmpty) {
          ref.read(searchQueryProvider.notifier).state = value;
        }
      },
    );
  }

  Widget _buildBookTile(Book book) {
    // 웹일 경우 각 이미지 URL에 대해 고유한 ViewType을 생성하여 등록합니다.
    if (kIsWeb) {
      // ignore: undefined_prefixed_name
      ui_web.platformViewRegistry.registerViewFactory(
        book.image,
            (int viewId) => html.ImageElement()
          ..src = book.image
          ..style.width = '100%'
          ..style.height = '100%'
          ..style.objectFit = 'cover'
          ..style.borderRadius = '8px', // ClipRRect 대신 CSS로 모서리 깎기
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 이미지 섹션: 웹과 모바일을 분기 처리
          SizedBox(
            width: 80,
            height: 110,
            child: kIsWeb
                ? HtmlElementView(viewType: book.image) // 웹: HTML <img> 태그 사용
                : ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                book.image,
                fit: BoxFit.cover,
              ),
            ), // 모바일/데스크탑: 일반 Image 위젯
          ),
          const SizedBox(width: 16),
          // 정보 섹션
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
                Text(
                  book.author,
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
                const SizedBox(height: 8),
                Text(
                  book.description,
                  style: const TextStyle(fontSize: 13, height: 1.4),
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