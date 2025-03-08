#!/bin/bash

# Проверка наличия файла
if [ $# -lt 1 ]; then
    echo "Использование: $0 <имя_файла_с_IP> [токен_ipinfo]"
    exit 1
fi

FILE="$1"
TOKEN="$2"

# Проверка существования файла
if [ ! -f "$FILE" ]; then
    echo "Ошибка: файл $FILE не найден"
    exit 1
fi

# Создаем директорию для результатов
RESULTS_FILE="ipinfo_results.log"

echo "Запрашиваем информацию для IP адресов из файла $FILE..."

# Счетчик для отслеживания прогресса
TOTAL=$(grep -v "^$" "$FILE" | wc -l)
COUNTER=0

# Обработка каждого IP адреса
while IFS= read -r ip || [[ -n "$ip" ]]; do
    # Пропускаем пустые строки
    [ -z "$ip" ] && continue

    # Увеличиваем счетчик
    ((COUNTER++))

    # Вывод прогресса
    echo -ne "Обработка: $COUNTER из $TOTAL IP-адресов (${ip}) [$(( COUNTER * 100 / TOTAL ))%]\r"

    # Формируем запрос
    if [ -n "$TOKEN" ]; then
        # С использованием токена
        RESPONSE=$(curl -s "https://ipinfo.io/${ip}?token=${TOKEN}")
    else
        # Без токена (ограниченный доступ)
        RESPONSE=$(curl -s "https://ipinfo.io/${ip}")
    fi

    # Сохраняем результат в файл
    echo "${RESPONSE}" >> "$RESULTS_FILE"

    # Вывод основной информации в консоль
    echo -e "\nИнформация о IP: $ip"
    echo "$RESPONSE" | grep -E '"city"|"region"|"country"|"org"|"hostname"|"loc"'
    echo "----------------------"

    # Задержка, чтобы не превысить лимиты запросов
    sleep 1
done < "$FILE"

echo -e "\nОбработка завершена. Результаты сохранены в директории $RESULTS_FILE"
