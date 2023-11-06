set http_proxy=http://username:password@proxyAddress:port
set https_proxy=https://username:password@proxyAddress:port

# Install from local cache:
pip download -r requirements.txt -d packages_dir
pip install -r requirements.txt --no-index --find-links=packages_dir

# Установка
pip install mysqlclient-1.3.7-cp34-none-win_amd64.whl
# Список установленных модулей
pip list
# Список зависимостей проекта сохранить в файл:
pip freeze > requirements.txt
