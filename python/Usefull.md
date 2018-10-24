# Полезные мелочи
Тут будут собраны всякие полезные моменты, которые могут облегчить процесс написания кода

## Подключение модулей из других папок
Для удобства в проекте все внешние подключаемые модули вынести в отдельную папку, например `include`.   
Допустим структура проекта выглядит вот так:  
![Structure](https://github.com/RTC-SCTB/Database/blob/master/python/Images/structure.png)  

Здесь в папке `include` лежат два модуля `RTCJoystick` и `PRiPWM`.  
Модуль `RPiPWM` можно подключить к файлу `test.py` таким образом:
```python
import sys
sys.path.append('include')
from MyRPiPWM import RPiPWM
```
Это эквивалентно тому, что мы положили файл `RPiPWM.py` рядом с файлом `test.py`.  
Поскольку модуль `RTCJoystick` требует подключения модуля `RTCEventMaster`, несмотря на то, что файлы лежат рядом, также
подключить модуль не получится, python не знает пути до `RTCEventMaster` и выдаст ошибку. Поэтому, чтобы его подключить
нужно написать вот так:
```python
import sys
sys.path.append('include/Joystick')
import RTCJoystick
``` 

Допустимы записи:
```python
import sys
sys.path.append('include')
sys.path.append('include/Joystick')
from MyRPiPWM import RPiPWM
import RTCJoystick
```
или
```python
import sys
sys.path.append('include/MyRPiPWM')
sys.path.append('include/Joystick')
import RTCJoystick
import RPiPWM

```