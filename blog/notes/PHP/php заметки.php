<?php

trim($oplata, chr(0xC2).chr(0xA0)); //удалить &nbsp;

$floor_temp = "7/14";
$floor = substr($floor_temp, 0, strpos($floor_temp, '/'));		//7
$floornum = substr($floor_temp, strpos($floor_temp, '/')+1);	//14

setlocale(LC_ALL, 'ru_RU.CP1251', 'rus_RUS.CP1251', 'Russian_Russia.1251', 'russian');

/**************** Комбинации ********************/
$n=5;
$values = array("A","B","C","D","E");
$rownum = 0;
for ($i=0; $i<=$n; $i++){
	for ($j=$i; $j<=$n; $j++){
		for ($k=$j; $k<$n; $k++){
			$rownum++;
			echo "$rownum: $i, $j, $k - $values[$i], $values[$j], $values[$k]<br>";
		}
	}
}

/************************************/

function brut36($A="0123456789", $N=1)
{
$base="0123456789abcdefghijklmnopqrstuvwxyz";
$b=strlen($A);
$count=pow($b, $N);
for ($i=0;$i<$count;$i++)
  echo strtr(str_pad(base_convert($i, 10, $b), $N, "0",
	STR_PAD_LEFT), $base, $A),"\r\n";
}

brut36("01", 3);

/*************** Навигация по статическим страницам *********************/

// Количество страниц
$total = 909;
// Определяем текущую страницу. Страницы должны быть jdev[число].php
$a=$_SERVER['REQUEST_URI'];
$page = substr($a, 5, -4);  
$first = '<a href= ./jdev1.php>первая</a> | ';
$last = ' | <a href= ./jdev' .$total. '.php>последняя</a>';
// Если значение $page меньше единицы или отрицательно
// переходим на первую страницу
// А если слишком большое, то переходим на последнюю
if(empty($page) or $page < 0) $page = 1;
  if($page > $total) $page = $total;

// Проверяем нужны ли стрелки назад
if ($page != 1) $pervpage = '<a href= ./jdev1.php><<</a>
                               <a href= ./jdev'. ($page - 1) .'.php><</a> ';
// Проверяем нужны ли стрелки вперед
if ($page != $total) $nextpage = ' <a href= ./jdev'. ($page + 1) .'.php>></a>
                                   <a href= ./jdev' .$total. '.php>>></a>';

// Находим две ближайшие станицы с обоих краев, если они есть
if($page - 2 > 0) $page2left = ' <a href= ./jdev'. ($page - 2) .'.php>'. ($page - 2) .'</a> | ';
if($page - 1 > 0) $page1left = '<a href= ./jdev'. ($page - 1) .'.php>'. ($page - 1) .'</a> | ';
if($page + 2 <= $total) $page2right = ' | <a href= ./jdev'. ($page + 2) .'.php>'. ($page + 2) .'</a>';
if($page + 1 <= $total) $page1right = ' | <a href= ./jdev'. ($page + 1) .'.php>'. ($page + 1) .'</a>';

// Вывод меню
echo $first.$pervpage.$page2left.$page1left.'<b>'.$page.'</b>'.$page1right.$page2right.$nextpage.$last;
echo ' Страница '.$page.' из '.$total;

/* Для POST запросов с JSON.stringify и c хедером 'application/json' */
if(isset($_SERVER["CONTENT_TYPE"]) && strpos($_SERVER["CONTENT_TYPE"], "application/json") !== false) {
    $_POST = array_merge($_POST, (array) json_decode(trim(file_get_contents('php://input')), true));
}

/* Чтобы JavaScript мог прочитать HTTP-заголовок ответа, сервер должен указать его имя в Access-Control-Expose-Headers */
header('Access-Control-Expose-Headers: X-Pagination-Current-Page, X-Pagination-Page-Count, X-Pagination-Per-Page, X-Pagination-Total-Count');

/* CORS */
Yii::$app->user->enableSession = false;

header('Access-Control-Allow-Origin: *');
header("Access-Control-Allow-Credentials: true");
header('Access-Control-Allow-Methods: GET, POST, PUT, PATCH, DELETE, HEAD, OPTIONS');
header('Access-Control-Max-Age: 1000');
header('Access-Control-Allow-Headers: Authorization,DNT,User-Agent,Keep-Alive,Content-Type,accept,origin,X-Requested-With');
header('Access-Control-Expose-Headers: X-Pagination-Current-Page, X-Pagination-Page-Count, X-Pagination-Per-Page, X-Pagination-Total-Count, Www-Authenticate');

if($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
   header( "HTTP/1.1 200 OK" );
   exit();
}