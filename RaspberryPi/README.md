# Raspberry Pi
Одноплатный компьютер, на основе которого мы собрали большую часть наших роботов.

Обычно работает на базе операционной системы [Raspbian](https://www.raspberrypi.org/downloads/raspbian/), которая
существует в двух вариантах: 
- `With Desktop` - образ с графическим интерфейсом и большим количеством всяких предустановленных штук (например Wolfram
Mathematica и Minecraft). 
- `Light` - облегченная версия образа (без всего, в том числе и графической оболчки). Он управляется только с помощью
командной строки.

### Распиновка
![GPIO](https://github.com/RTC-SCTB/Database/blob/master/RaspberryPi/Images/rpiGpio.png)   
Пины Raspberry Pi - основной способ взаимодействия с внешним миром. На них выведен ряд интерфейсов:
`I2C`,`UART`, `SPI`. Также к Raspberry можно подключать различную электронику напрямую к пинам ввода-вывода (GPIO). 
Raspberry позволяет читать состояние каждого из этих пинов, а также программно их задавать.
Встроенного АЦП у Raspberry нет, часов реального времени тоже. Поэтому ШИМ, например, на пинах стоит генерировать
крайне ограниченно, поскольку стабильность не гарантируется.

### Первый запуск
Питание Raspberry осуществляется либо через порт Micro-USB (он используется *ТОЛЬКО* для питания, никакие данные по нему
не передаются), либо через GPIO. Причем если питание подавать через Micro-USB, на GPIO появляется напряжение 5 и 3.3 В, 
которые можно использовать для подключения внешней электроники. **Не уверен** работает ли это в обратном направлении 
(появится ли напряжение на micro-usb если подать питание на GPIO). Также **не уверен**, будет ли работать все, если 
подать напряжение 3.3 В на соответствующие GPIO.

Raspberry Pi использует в качестве жесткого диска Micro SD карту, на которой разворачивается образ Raspbian'a. 
SD карту стоит брать объемом не меньше 8 Гб, классом не ниже 10 (цифра которая написана прямо на карте, обычно обведена
в кружок).   
**Плюс**: можно вытащить карту из одной Raspberry и воткнуть в другую, и (особенно если модели Raspberry одинаковые) все 
заработает так, как будто бы вы поменяли сами Raspberry местами.   
**Минус**: часть SD карты используется в качестве дополнительной оперативной памяти, поэтому карта изнашивается гораздо 
быстрее, чем от нее ожидаешь.

Для подключения по умолчанию:  
Логин: `pi`  
Пароль: `raspberry`  

Забавный факт - к оболочке Raspberry можно подключиться при помощи UART, также как если бы это был обычный терминал.

### Полезное:
- Если нет клавиатуры и дисплея, которые можно было бы подключить к Raspberry при первом включении: 
[Headless start](https://www.raspberrypi.org/documentation/configuration/wireless/headless.md) 
(Включить SSH и подключиться к Wi-Fi, если у Raspberry есть встроенный)

- Настройка интерфейсов.  
По умолчанию у Raspberry Pi выключены все интерфейсы, включая ssh. Поэтому первое что вы делаете при запуске - вводите
команду `sudo raspi-config` и включаем все необходимое: ssh, камеру, i2c и т.д. Здесь же можно отключить доступ к 
оболочке по UART, но оставить возможность пользоваться самим интерфейсом (одновременно, увы, нельзя).

- Добавление файла в автозагрузку:
  1. Открываем файл rc.local: `sudo nano /etc/rc.local`
  2. Добавляем в конце файла строчку `/home/pi/autorun.sh`
  3. Создаем файл скрипта `autorun.sh` в домашней директории и вписываем в него все, что должно запускаться при
   автозагрузке.  
  4. Не забываем дать скрипту права на выполнение: `sudo chmod +x autorun.sh`  
  
   Пример файла `autorun.sh` лежит в этой же папке.  
   ***ВАЖНО:*** этот скрипт выполняется ДО того как загружается графический интерфейс, поэтому если надо чтобы 
   запускалась какая то графическая программа (например таймер для кубка), процедура будет другой.
   
- Задать фиксированный IP адрес:
  1. Открываем: `sudo nano /etc/dhcpcd.conf`
  2. Дописываем/раскомментируем строки:
  ```bash
  interface eth0
  static ip_address=192.168.42.230
  static routers=192.168.42.255
  static domain_name_servers=192.168.42.255
  ```
  Где ip_address - тот IP который будет зафиксирован для данной Raspberry Pi.
  
- Полезная информация о файле `/boot/config.txt` [тут](http://wikihandbk.com/wiki/Raspberry_Pi:Настройка/config.txt)
  Через этот файл настраивается конфигурация работы Raspberry Pi, например сколько памяти выделяется под графику, 
  настройка аудио-выхода, настройка HDMI, параметры загрузки ядра, параметры работы интерфейсов и т.д. и т.п.
  
- [Основная документация по Raspberry Pi](https://www.raspberrypi.org/documentation/)

- [Перевести SD карту Raspberry Pi в режим Read Only](https://habr.com/post/400011/) (продлевает срок жизни SD карты)

- [Добавление кнопки выключения](https://www.element14.com/community/docs/DOC-78055/l/adding-a-shutdown-button-to-the-raspberry-pi-b)
(реализация через Python скрипт)
  
- [Добавление программ с GUI в автозагрузку](http://www.raspberry-projects.com/pi/pi-operating-systems/raspbian/auto-running-programs-gui)
 (для Raspbian с графическим интерфейсом) 


- Активация CAN интерфейса:
  1. С помощью `raspi-config` включить SPI.
  2. Открыть файл `config.txt`: `sudo nano /boot/config.txt`
  3. Дописать/раскомментировать строчки:
      ```bash
      dtparam=spi=on
      dtoverlay=mcp2515-can0,oscillator=16000000,interrupt=25
      dtoverlay=spi-bcm2835-overlay
      ```
      ***Важно:*** цифра `interrupt` может изменяться в зависимости от платы. Это номер GPIO к которому подключен пин 
      CAN Interrupt (смотрите схему платы).

  4. После перезагрузки можно пользоваться CAN интерфейсом. Включается командой 
      ```bash
      sudo ip link set can0 up type can bitrate 500000
      ```

      ***Важно:*** bitrate также может меняться в зависимости от устройства. Например полетный контроллер Naza работает
       с `bitrate 1000000`
  
  Для удобства можно поставить из репозиториев пакет `can-utils` и пользоваться им для работы с сетью CAN (слушать что 
  там летает, отправлять свои пакеты).  