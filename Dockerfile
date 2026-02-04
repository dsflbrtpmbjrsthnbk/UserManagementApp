# Используем официальный .NET SDK образ для сборки
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /app

# Копируем файл проекта и восстанавливаем зависимости
COPY *.csproj ./
RUN dotnet restore

# Копируем все остальные файлы и собираем приложение
COPY . ./
RUN dotnet publish -c Release -o out

# Используем runtime образ для запуска
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=build /app/out .

# Открываем порт
EXPOSE 8080

# Устанавливаем переменную окружения для порта
ENV ASPNETCORE_URLS=http://+:8080

# Запускаем приложение
ENTRYPOINT ["dotnet", "UserManagementApp.dll"]
