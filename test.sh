#!/bin/bash

# Конфигурационные параметры
PROCESS_NAME="test"
LOG_FILE="/var/log/monitoring.log"
MONITORING_URL="https://test.com/monitoring/test/api"
LAST_PID_FILE="/tmp/${PROCESS_NAME}_last_pid"
CURL_TIMEOUT=5  # Таймаут для curl в секундах

# Проверяем, запущен ли процесс
current_pid=$(pgrep -o "$PROCESS_NAME")

if [ -n "$current_pid" ]; then
    # Если процесс запущен
    last_pid=""
    if [ -f "$LAST_PID_FILE" ]; then
        last_pid=$(cat "$LAST_PID_FILE")
    fi

    if [ "$current_pid" != "$last_pid" ]; then
        # Если процесс был перезапущен
        echo "$(date +'%Y-%m-%d %H:%M:%S') - Process '$PROCESS_NAME' restarted (PID: $current_pid)" >> "$LOG_FILE"
        echo "$current_pid" > "$LAST_PID_FILE"
    fi

    # Пытаемся стучаться на сервер мониторинга с таймаутом
    http_code=$(curl -s -o /dev/null -w "%{http_code}" --max-time "$CURL_TIMEOUT" -L "$MONITORING_URL")
    if [ "$http_code" -ne 200 ]; then
        echo "$(date +'%Y-%m-%d %H:%M:%S') - Monitoring server is unreachable or returned HTTP code $http_code" >> "$LOG_FILE"
    fi
fi
