Инструкция по установке Red OS 8 и настройке окружения разработчикаДанное руководство описывает полный цикл подготовки рабочей станции: от установки ОС до настройки стека C++/Qt/PostgreSQL/Git.СодержаниеУстановка Red OS 8Первичная настройка системыНастройка Git и SSHИнструменты разработки (GCC, CMake, Ninja)Установка и настройка Qt Creator и Qt 5Установка и настройка PostgreSQLДополнительное ПОКонтрольный чек-лист1. Установка Red OS 81.1. Подготовка носителяСкачайте ISO-образ Red OS 8 (Рабочая станция).Запишите образ на USB-накопитель (не менее 8 ГБ).[!WARNING]Внимание: Команда dd полностью стирает данные на целевом устройстве.Под Linux:Bash# Замените /dev/sdX на путь к вашей флешке (проверить через lsblk)
sudo dd if=RedOS-8.0-Workstation.iso of=/dev/sdX bs=4M status=progress oflag=sync
Под Windows: Используйте Rufus или BalenaEtcher в режиме «DD / образ диска».1.2. Процесс установкиВ BIOS/UEFI: отключите Secure Boot и установите приоритет загрузки с USB.В меню загрузчика выберите «Установка Red OS».Разметка диска:Для чистой установки выберите «Автоматическая разметка».Для разделения данных выберите «Вручную» (рекомендуется создать отдельные разделы /, /home и swap).Пользователи:Задайте пароль для root.Создайте пользователя (например, akharin) и поставьте галочку «Сделать администратором» (добавление в группу wheel).2. Первичная настройка системыОбновите пакетную базу и системные компоненты:Bash# Очистка кэша и обновление
sudo dnf clean all
sudo dnf makecache
sudo dnf -y update

# Перезагрузка после обновления ядра
sudo reboot
3. Настройка Git и SSH3.1. Установка и базовая конфигурацияBashsudo dnf -y install git

git config --global user.name  "Имя Фамилия"
git config --global user.email "user@example.com"
git config --global core.editor "nano"
3.2. Настройка SSH-доступаГенерация ключа для авторизации на внутреннем Git-сервере:Bashssh-keygen -t ed25519 -C "user@example.com"
Закрытый ключ: ~/.ssh/id_ed25519Открытый ключ: ~/.ssh/id_ed25519.pubСкопируйте содержимое открытого ключа и добавьте его в настройки профиля на сервере (например, Gitlab/Gitea):Bashcat ~/.ssh/id_ed25519.pub
Проверка соединения:Bashssh -T git@git.0825.vniief.ru
4. Инструменты разработки (GCC, CMake, Ninja)Установите базовый набор компиляторов и систем сборки:Bash# Установка группы инструментов разработки
sudo dnf groupinstall -y "Development Tools"

# Установка дополнительных утилит
sudo dnf install -y gcc-c++ cmake ninja-build gdb
5. Установка и настройка Qt Creator и Qt 55.1. Установка пакетовBash# Qt Creator и зависимости
sudo dnf install -y qt-creator libdrm

# Комплект разработчика Qt 5
sudo dnf install -y \
    qt5-qtbase-devel \
    qt5-qtdeclarative-devel \
    qt5-qtquickcontrols2 \
    qt5-qtquickcontrols2-devel \
    qt5-qtsvg-devel \
    qt5-qttools \
    qt5-qttools-libs-designer \
    qt5-qttools-devel
5.2. Конфигурация Qt CreatorЗапустите Qt Creator.Перейдите в Инструменты → Параметры → Сборка и запуск.Qt Versions: Нажмите «Добавить» и укажите путь /usr/bin/qmake-qt5.Компиляторы: Убедитесь, что GCC (C++) определен (путь /usr/bin/g++).Комплекты (Kits): - Выберите существующий или создайте новый.Укажите созданный профиль Qt и компилятор GCC.6. Установка и настройка PostgreSQL6.1. Установка сервераBash# Поиск и установка (пример для версии 15)
sudo dnf install -y postgresql15-server postgresql15
6.2. Инициализация и запускBash# Инициализация БД
sudo /usr/pgsql-15/bin/postgresql-15-setup initdb

# Включение автозапуска и старт
sudo systemctl enable --now postgresql-15
6.3. Настройка доступаУстановите пароль для системного пользователя базы данных:Bashsudo -u postgres psql
# В консоли psql:
ALTER USER postgres WITH ENCRYPTED PASSWORD 'Ваш_Сложный_Пароль';
\q
7. Дополнительное ПОДля установки Telegram Desktop:Bashsudo dnf install -y telegram-desktop
8. Контрольный чек-листЗапустите эти команды для проверки готовности системы:КомпонентКоманда проверкиОжидаемый результатSudosudo whoamirootGitgit --versionВерсия gitКомпиляторg++ --versionВерсия GCCQtqmake-qt5 -vQt version 5.xPostgreSQLsystemctl status postgresql-15active (running)SSHls ~/.ssh/id_ed25519Наличие файлов ключейДокументация актуальна для Red OS 8.0.
