# demo

## architecture

```
lib/  
├── core/                # 공용 유틸리티, 에러 처리, 네트워크 클라이언트  
├── domain/              # 비즈니스 로직 (순수 Dart)  
│   ├── entities/        # 핵심 데이터 모델  
│   ├── repositories/    # 저장소 인터페이스 (추상 클래스)  
│   └── usecases/        # 구체적인 비즈니스 행위  
├── data/                # 데이터 소스 및 구현체  
│   ├── models/          # API 응답 DTO (JSON 직렬화)  
│   ├── datasources/     # 원격/로컬 데이터 소스 (API 호출)  
│   └── repositories/    # 도메인 저장소의 구현체  
└── presentation/        # UI 및 상태 관리  
    ├── providers/       # Riverpod 또는 Bloc 등의 상태 관리  
    ├── screens/         # 화면 위젯  
    └── widgets/         # 재사용 가능한 컴포넌트
```
