## Скрипт на bash для мониторинга процесса test в среде linux
1. Копируем скрипт в нужную директорию
2. Создайте файл /etc/systemd/system/process-monitoring.service
3. Затем создайте таймер /etc/systemd/system/process-monitoring.timer:
4. Активируйте юнит и таймер:
```
   sudo systemctl daemon-reload
   sudo systemctl enable process-monitoring.timer
   sudo systemctl start process-monitoring.timer
```
