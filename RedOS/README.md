# Инструкция по установке Red OS 8 и настройке окружения
Данное руководство описывает полный цикл подготовки рабочей станции: от установки ОС до настройки стека C++ / Qt / PostgreSQL / Git.
1. Подготовка и установка ОС:
  1.Образ: Скачайте ISO-образ Red OS 8 (редакция «Рабочая станция»).
  2.Запись: Используйте Rufus или BalenaEtcher в режиме «DD / образ диска» (Windows) или команду dd (Linux).
  3.Внимание: Команда dd полностью стирает данные на флешке!BIOS/UEFI: Отключите Secure Boot и установите приоритет загрузки с USB.
  4.Разметка диска: Выберите «Автоматическая разметка» (для чистой установки) или «Вручную» (создайте разделы /, /home и swap).
  5.Пользователь: Обязательно отметьте пункт «Сделать администратором» (добавление в группу wheel).

2. Полное обновление системы
    После первой загрузки обновите пакетную базу:
```bash
# Очистка кэша и построение нового
sudo dnf clean all
sudo dnf makecache
```
### Обновление системы
```bash
sudo dnf -y update
```
Важно: После обновления ядра необходима перезагрузка:
```bash
sudo reboot
```
3. Настройка Git и SSHУстановите Git и настройте глобальные параметры:Bashsudo dnf -y install git

```bash
git config --global user.name "Имя Фамилия"
git config --global user.email "user@example.com"
git config --global core.editor "nano"
```
Генерация SSH-ключаДля безопасной работы с внутренним Git-сервером:Bashssh-keygen -t ed25519 -C "user@example.com"

### Просмотр ключа для добавления в профиль (напр. GitLab)
cat ~/.ssh/id_ed25519.pub

### Проверка соединения
ssh -T git@git.0825.vniief.ru
4. Инструменты разработкиУстановите основной набор компиляторов и систем сборки:Bash# Группа инструментов разработки
sudo dnf groupinstall -y "Development Tools"

### Дополнительные утилиты
sudo dnf install -y gcc-c++ cmake ninja-build gdb
5. Установка и настройка Qt 5Установка среды и библиотек:Bashsudo dnf install -y qt-creator libdrm \
qt5-qtbase-devel \
qt5-qtdeclarative-devel \
qt5-qtquickcontrols2 \
qt5-qtquickcontrols2-devel \
qt5-qtsvg-devel \
qt5-qttools \
qt5-qttools-libs-designer \
qt5-qttools-devel
Настройка Qt Creator: Перейдите в Инструменты → Параметры → Сборка и запуск. Проверьте пути в Qt Versions (/usr/bin/qmake-qt5) и Компиляторы (/usr/bin/g++).6. Установка и настройка PostgreSQL 15Bash# Установка сервера и клиента
sudo dnf install -y postgresql15-server postgresql15

### Инициализация базы данных
sudo /usr/pgsql-15/bin/postgresql-15-setup initdb

### Добавление в автозагрузку и запуск
sudo systemctl enable --now postgresql-15
Настройка пароля администратора (в консоли psql):SQLALTER USER postgres WITH ENCRYPTED PASSWORD 'Ваш_Сложный_Пароль';
\q
7. Контрольный чек-листЗапустите команды для финальной проверки окружения:КомпонентКоманда проверкиПрава rootsudo whoamiGitgit --versionКомпиляторg++ --versionQt / qmakeqmake-qt5 -vPostgreSQLsystemctl status postgresql-15SSH-ключls -l ~/.ssh/id_ed25519Дополнительно: Для установки Telegram Desktop используйте: sudo dnf install -y telegram-desktop.Документация актуальна для: Red OS 8.0. 
Последнее обновление: 2026-01-15.
