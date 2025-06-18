# My Proto Repository

Этот репозиторий содержит Protocol Buffer определения и сгенерированный код для микросервисов.

## Структура проекта

```
├── proto/              # Protocol Buffer определения
│   ├── filter/         # Сервис фильтрации
│   └── prod_service/   # Сервис продуктов
├── gen/                # Сгенерированный код
│   ├── go/            # Go код для gRPC сервисов
│   ├── swagger/       # OpenAPI/Swagger документация
│   └── typescript/    # TypeScript клиентский код
├── buf.gen.yaml       # Конфигурация генерации buf
├── buf.work.yaml      # Конфигурация workspace buf
├── package.json       # npm зависимости для TypeScript
├── tsconfig.json      # TypeScript конфигурация
└── Makefile          # Команды для сборки и генерации
```

## Использование

### Генерация всех артефактов

```bash
make proto
```

Эта команда создаст:

- Go код для gRPC сервисов
- OpenAPI/Swagger документацию
- TypeScript клиентский код

### Генерация только кода

```bash
make gen
```

### Создание TypeScript клиентского пакета

```bash
make client-package
```

## Сгенерированные артефакты

После выполнения команды `make proto` у вас будут созданы следующие артефакты:

### Go код

- `gen/go/prod_service/` - Go gRPC клиент и сервер для Product Service
- `gen/go/filter/` - Go код для фильтров и сортировки

### Swagger/OpenAPI документация

- `gen/swagger/prod_service/products/v1/service.swagger.json` - OpenAPI спецификация для Product Service
- `gen/swagger/filter/v1/filter.swagger.json` - OpenAPI спецификация для фильтров
- `swagger-ui.html` - HTML файл для просмотра Swagger документации в браузере

### TypeScript клиент

- `gen/typescript/` - TypeScript определения и gRPC-Web клиенты
- `dist/` - Скомпилированный JavaScript код
- `client-example.ts` - Пример использования TypeScript клиента

## Просмотр документации

Чтобы посмотреть Swagger документацию:

1. Запустите локальный HTTP сервер в корне проекта:

   ```bash
   python3 -m http.server 8000
   # или
   npx serve .
   ```

2. Откройте в браузере: `http://localhost:8000/swagger-ui.html`

## Зависимости

- [Buf](https://buf.build/) - для работы с Protocol Buffers
- [Go](https://golang.org/) - для сгенерированного кода
- [gRPC-Go](https://grpc.io/docs/languages/go/) - для gRPC сервисов
- [Node.js](https://nodejs.org/) - для TypeScript генерации
- [TypeScript](https://www.typescriptlang.org/) - для клиентского кода

## Сервисы

### Filter Service

Сервис для фильтрации и сортировки данных.

### Product Service

Сервис для управления продуктами.

## Примеры использования

### Запуск gRPC сервера

```bash
go run server-example.go
```

### Использование TypeScript клиента

См. файл `client-example.ts` для примера работы с gRPC-Web клиентом.

### Тестирование gRPC API

Используйте grpcurl для тестирования:

```bash
# Список доступных сервисов
grpcurl -plaintext localhost:50051 list

# Вызов метода
grpcurl -plaintext -d '{
  "name": "Test Product",
  "description": "Test Description",
  "price": "100",
  "currency_id": 1,
  "rating": 5,
  "category_id": "electronics",
  "specification": "Test spec"
}' localhost:50051 prod_service.products.v1.ProductService/CreateProduct
```

## Структура генерированных файлов

```
gen/
├── go/                          # Go gRPC код
│   ├── prod_service/
│   │   ├── go.mod
│   │   └── products/v1/
│   │       ├── product.pb.go    # Protobuf структуры
│   │       ├── service.pb.go    # Request/Response структуры
│   │       └── service_grpc.pb.go # gRPC сервер и клиент
│   └── filter/
│       ├── go.mod
│       └── v1/
│           ├── filter.pb.go
│           └── sort.pb.go
├── swagger/                     # OpenAPI/Swagger документация
│   ├── prod_service/products/v1/
│   │   ├── service.swagger.json
│   │   └── product.swagger.json
│   └── filter/v1/
│       ├── filter.swagger.json
│       └── sort.swagger.json
└── typescript/                  # TypeScript gRPC-Web клиенты
    ├── prod_service/products/v1/
    │   ├── ServiceServiceClientPb.ts
    │   ├── service_pb.d.ts
    │   ├── service_pb.js
    │   ├── product_pb.d.ts
    │   └── product_pb.js
    └── filter/v1/
        ├── filter_pb.d.ts
        ├── filter_pb.js
        ├── sort_pb.d.ts
        └── sort_pb.js
```
