# Используем образ с Go
FROM golang:1.23.2-alpine AS builder

# Устанавливаем рабочий каталог внутри контейнера
WORKDIR /app

# Копируем файлы go.mod и go.sum для кэширования зависимостей
COPY go.mod go.sum ./

# Загружаем зависимости
RUN go mod download

# Копируем остальной код
COPY . .

# Собираем приложение
RUN go build -o hello-go .

# Используем минимальный образ для запуска
FROM alpine:latest

# Копируем исполняемый файл из предыдущего этапа
COPY --from=builder /app/hello-go /bin/hello-go

# Запускаем приложение при старте контейнера
ENTRYPOINT ["/bin/hello-go"]
