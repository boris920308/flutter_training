// 테스트를 위한 간단한 도서 모델
class MockBook {
  final String title;
  final String author;
  final String image;
  final String description;

  MockBook({
    required this.title,
    required this.author,
    required this.image,
    required this.description
  });
}

final List<MockBook> mockBooks = List.generate(10, (index) => MockBook(
  title: '플러터 클린 아키텍처 $index',
  author: '코딩마스터 $index',
  // picsum.photos는 매우 안정적인 무료 이미지 서비스입니다.
  // /seed/숫자/ 를 넣으면 매번 다른 이미지를 가져옵니다.
  image: 'https://picsum.photos/seed/${index + 100}/200/300',
  description: '이 책은 네이버 API와 SOLID 원칙을 이용해 유지보수가 쉬운 앱을 만드는 방법을 설명합니다...',
));