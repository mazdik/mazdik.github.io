## Simple vanilla single page application

Тестовое задание.  
Задание разделено на 2 части. Базовую и дополнительную. Базовая часть обязательна для выполнения. Выполнение дополнительной рассматривается в качестве плюса. Так же плюсом будет выполнение ограничений указанных после основных частей. 

Базовая часть.  
Создать базу данных в выбранной СУБД (sqlite, mysql, postgreesql или другая SQL-совместимая СУБД). Создать необходимые для выполнения задания таблицы и справочные данные (сделать это в виде sql скрипта). 
Написать веб приложение заполнения формы обратной связи с сохранением результата в базу данных. Приложение должно реализовывать возможность просмотра и удаления добавленных записей.  

Добавление комментариев. После запуска приложения при обращении по относительному пути /comment/ должна отображаться форма для заполнения. Форма состоит из следующих полей:  
    • фамилия  
    • имя  
    • отчество  
    • регион  
    • город  
    • контактный телефон  
    • e-mail  
    • комментарий  
Поля фамилия, имя и комментарий являются обязательными. Поле комментарий текстовое. Для полей телефон и email следует производить проверку ввода. Номер телефона в формате «(код города) номер». Поля с некорректным вводом и не заполненные обязательные поля должны визуально выделяться красным цветом. Поля регион и город являются выпадающими списками, при этом список выбора поля город зависит от выбранного поля регион. Данные для этих списков должны храниться в СУБД. Значение в поля город должно динамически подгружаться по технологии ajax в соответствии с выбранным полем регион. 

Дополнительная часть.  
Просмотр комментариев. При обращении по относительному пути /view/ должна выводиться таблица со списком добавленных комментариев. В этом же представлении должна быть возможность удалить определенную запись. 

Удаление комментариев. В представлении просмотра комментариев реализовать возможность удаления отдельно выбранного комментария. 

Просмотр статистики.  При обращении по относительному пути /stat/ должна выводиться таблица со списком тех регионов у которых количество комментариев больше 5, выводить так же и количество комментариев по каждому региону. Каждая строчка должны быть ссылкой на список города этого региона в котором отображается количество комментариев по этому городу.

Не обязательные ограничения  
При реализации не использовать библиотек/модулей или фреймворков не входящих в стандартную библиотеку javascript.