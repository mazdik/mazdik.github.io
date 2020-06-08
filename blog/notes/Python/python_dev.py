set http_proxy=http://username:password@proxyAddress:port
set https_proxy=https://username:password@proxyAddress:port

python --version
python -m pip install --upgrade pip

# Install from local cache:
pip download -r requirements.txt -d packages_dir
pip install -r requirements.txt --no-index --find-links=packages_dir

# Веб сервер для разработки
python manage.py runserver
# Установка
pip install virtualenv
pip install mysqlclient-1.3.7-cp34-none-win_amd64.whl
pip install cx_Oracle --pre
pip install --trusted-host pypi.python.org wfastcgi
# Удаление
pip uninstall cx_Oracle
# Удалить все пакеты
virtualenv --clear MYENV
# Обновление
pip install [package_name] --upgrade
# Список установленных модулей
pip list
# Список зависимостей проекта сохранить в файл:
pip freeze > requirements.txt

# Установка
virtualenv venv
venv\Scripts\activate
pip install -r requirements.txt
virtualenv -p python3.6 venv

# Linux
python3.6 -m venv venv
source venv/bin/activate
pip3.6 install -r requirements.txt

# Если ошибка Failed building wheel
pip install --upgrade wheel
pip install --upgrade setuptools

# Настройки pip
On Unix $HOME/.config/pip/pip.conf
On Windows %APPDATA%\pip\pip.ini
[global]
trusted-host = pypi.python.org

# WFastCGI в консоле под администратором
wfastcgi-enable

# pywin32
this file - pywintypes36.dll
From -> "Python36/Lib/site-packages/pywin32_system32"
To -> 'Python36/Lib/site-packages/win32'

# Apache + Flask on Windows
https://www.lfd.uci.edu/~gohlke/pythonlibs/#mod_wsgi
# httpd.conf
LoadFile "C:/Python36/python36.dll"
LoadModule wsgi_module C:/Python36/Lib/site-packages/mod_wsgi/server/mod_wsgi.cp36-win_amd64.pyd
WSGIPythonHome "C:/Python36"
WSGIScriptAlias / "F:/app/service.wsgi"
DocumentRoot "F:/app"
<Directory "F:/app">
    Require all granted
</Directory>
# service.wsgi
import sys
sys.path.insert(0, 'F:/1')
from app import app as application
