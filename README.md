# My Proto Repository

Этот репозиторий содержит Protocol Buffer определения и сгенерированный Go код для микросервисов.

## Структура проекта

```
├── proto/              # Protocol Buffer определения
│   ├── filter/         # Сервис фильтрации
│   └── prod_service/   # Сервис продуктов
├── gen/go/            # Сгенерированный Go код
│   ├── filter/        # Go код для сервиса фильтрации
│   └── prod_service/  # Go код для сервиса продуктов
├── buf.gen.yaml       # Конфигурация генерации buf
├── buf.work.yaml      # Конфигурация workspace buf
└── Makefile          # Команды для сборки и генерации

```

## Использование

### Генерация кода
```bash
make generate
```

### Сборка проекта
```bash
make build
```

## Зависимости

- [Buf](https://buf.build/) - для работы с Protocol Buffers
- [Go](https://golang.org/) - для сгенерированного кода
- [gRPC-Go](https://grpc.io/docs/languages/go/) - для gRPC сервисов

## Сервисы

### Filter Service
Сервис для фильтрации и сортировки данных.

### Product Service
Сервис для управления продуктами.
