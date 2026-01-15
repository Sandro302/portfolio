Инструкция по установке Red OS 8 и настройке окружения разработчикаДанное руководство описывает полный цикл подготовки рабочей станции: от установки ОС до настройки стека C++ / Qt / PostgreSQL / Git.СодержаниеУстановка Red OS 8Первичная настройка системыНастройка Git и SSHИнструменты разработки (GCC, CMake, Ninja)Установка и настройка Qt Creator и Qt 5Установка и настройка PostgreSQLДополнительное ПОКонтрольный чек-лист1. Установка Red OS 81.1. Подготовка носителяСкачайте ISO-образ Red OS 8 (редакция «Рабочая станция»).Запишите образ на USB-накопитель (не менее 8 ГБ).[!WARNING]Внимание: Команда dd полностью стирает все данные на целевом устройстве!Под Linux:Bash# Замените /dev/sdX на путь к вашей флешке (можно проверить через lsblk)
sudo dd if=RedOS-8.0-Workstation.iso of=/dev/sdX bs=4M status=progress oflag=sync
Под Windows: Используйте Rufus или BalenaEtcher в режиме «DD / образ диска».1.2. Процесс установкиBIOS/UEFI: отключите Secure Boot и установите приоритет загрузки с USB.В меню загрузчика выберите «Установка Red OS».Разметка диска:Для чистой установки выберите «Автоматическая разметка».Для продвинутой настройки выберите «Вручную» (создайте разделы /, /home и swap).Пользователи:Задайте пароль для root.Создайте рабочего пользователя и обязательно отметьте пункт «Сделать администратором» (добавление в группу wheel).2. Первичная настройка системыОбновите пакетную базу и системные компоненты до актуального состояния:Bash# Очистка кэша и построение нового кэша метаданных
sudo dnf clean all
sudo dnf makecache

# Полное обновление системы
sudo dnf -y update

# Перезагрузка (необходима после обновления ядра)
sudo reboot
3. Настройка Git и SSH3.1. Установка и базовая конфигурацияBashsudo dnf -y install git

git config --global user.name  "Имя Фамилия"
git config --global user.email "user@example.com"
git config --global core.editor "nano"
3.2. Настройка SSH-доступаДля безопасной работы с внутренним Git-сервером сгенерируйте SSH-ключ:Bashssh-keygen -t ed25519 -C "user@example.com"
Закрытый ключ: ~/.ssh/id_ed25519Открытый ключ: ~/.ssh/id_ed25519.pubСкопируйте содержимое открытого ключа и добавьте его в настройки профиля на сервере (напр. GitLab):Bashcat ~/.ssh/id_ed25519.pub
Проверка соединения:Bashssh -T git@git.0825.vniief.ru
4. Инструменты разработки (GCC, CMake, Ninja)Установите стандартный набор компиляторов и систем сборки:Bash# Установка основной группы инструментов
sudo dnf groupinstall -y "Development Tools"

# Установка дополнительных утилит
sudo dnf install -y gcc-c++ cmake ninja-build gdb
5. Установка и настройка Qt Creator и Qt 55.1. Установка пакетовBash# Среда разработки и зависимости
sudo dnf install -y qt-creator libdrm

# Заголовочные файлы и библиотеки Qt 5
sudo dnf install -y \
    qt5-qtbase-devel \
    qt5-qtdeclarative-devel \
    qt5-qtquickcontrols2 \
    qt5-qtquickcontrols2-devel \
    qt5-qtsvg-devel \
    qt5-qttools \
    qt5-qttools-libs-designer \
    qt5-qttools-devel
5.2. Конфигурация Qt CreatorЗапустите Qt Creator.Перейдите в меню: Инструменты → Параметры → Сборка и запуск.Qt Versions: Нажмите «Добавить» и укажите путь к исполняемому файлу /usr/bin/qmake-qt5.Компиляторы: Убедитесь, что GCC (C++) определен автоматически (путь /usr/bin/g++).Комплекты (Kits):Выберите комплект по умолчанию или создайте новый.Выберите нужную версию Qt и компилятор.6. Установка и настройка PostgreSQL6.1. Установка сервераBash# Установка 15-й версии сервера и клиента
sudo dnf install -y postgresql15-server postgresql15
6.2. Инициализация и запускBash# Первоначальная инициализация базы данных
sudo /usr/pgsql-15/bin/postgresql-15-setup initdb

# Добавление в автозагрузку и немедленный запуск
sudo systemctl enable --now postgresql-15
6.3. Настройка пароля администратораЗадайте пароль для системной учетной записи БД:Bashsudo -u postgres psql
Внутри консоли psql выполните:SQLALTER USER postgres WITH ENCRYPTED PASSWORD 'Ваш_Сложный_Пароль';
\q
7. Дополнительное ПОДля установки Telegram Desktop выполните:Bashsudo dnf install -y telegram-desktop
8. Контрольный чек-листЗапустите следующие команды для финальной проверки окружения:КомпонентКоманда проверкиОжидаемый результатSudosudo whoamirootGitgit --versiongit version 2.x.xКомпиляторg++ --versiong++ (GCC) x.x.xQtqmake-qt5 -vUsing Qt version 5.x.xPostgreSQLsystemctl status postgresql-15active (running)SSHls -l ~/.ssh/id_ed25519Файл существуетДокументация актуальна для: Red OS 8.0Последнее обновление: 2026-01-15
