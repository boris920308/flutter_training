import 'package:flutter/material.dart';

import '../../../core/mocks/mock_books.dart';

class BookSearchScreen extends StatefulWidget {
  const BookSearchScreen({super.key});

  @override
  State<BookSearchScreen> createState() => _BookSearchScreenState();
}

class _BookSearchScreenState extends State<BookSearchScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // 웹과 모바일 대응을 위한 반응형 레이아웃 계산
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
              // 1. 검색창 영역
              _buildSearchBar(),
              const SizedBox(height: 20),

              // 2. 결과 리스트 영역
              Expanded(
                child: ListView.separated(
                  itemCount: mockBooks.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final book = mockBooks[index];
                    return _buildBookTile(book);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 검색바 위젯 분리 (Single Responsibility)
  Widget _buildSearchBar() {
    return TextField(
      controller: _controller,
      decoration: InputDecoration(
        hintText: '책 제목, 저자명을 입력하세요',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () => _controller.clear(),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.grey[100],
      ),
      onSubmitted: (value) {
        print('검색 실행: $value');
        // 나중에 여기서 API 호출 로직 연결
      },
    );
  }

  // 도서 아이템 위젯 분리
  Widget _buildBookTile(MockBook book) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              book.image,
              width: 80,   // 성공 시 이미지 너비
              height: 110, // 성공 시 이미지 높이
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                // 로딩 중에도 크기를 고정합니다.
                return Container(
                  width: 80,
                  height: 110,
                  color: Colors.grey[200],
                  child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                );
              },
              // 🌟 핵심 수정: 에러 시에도 크기를 고정합니다. 🌟
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 80,   // 여기도 똑같이 고정
                  height: 110, // 여기도 똑같이 고정
                  color: Colors.grey[300], // 회색 배경
                  alignment: Alignment.center,
                  // 빨간색 에러 메시지 대신 깔끔한 아이콘으로 대체
                  child: const Icon(Icons.broken_image, color: Colors.grey),
                );
              },
            ),
          ),
          const SizedBox(width: 16),
          // 책 정보
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