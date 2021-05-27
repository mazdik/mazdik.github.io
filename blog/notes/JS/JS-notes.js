/* Проверка на пустоту */
if(value) {
/* null | undefined | NaN | "" | 0 | false */
}

/* Если ли значение в списке */
let found = ['a','b','c'].indexOf(str) >= 0;
let found = [1,3,12].indexOf(foo) > -1;
let found = arr1.some(r=> arr2.includes(r)); // ES2016
let found = arr1.some(r=> arr2.indexOf(r) >= 0); // ES6
// arrays equal
arr1.every(r => arr2.includes(r));
// arrays diff
function diff (a1, a2) {
    return a1.filter(i => !a2.includes(i)).concat(a2.filter(i => !a1.includes(i)));
}
// arr1 not in arr2
arr1.filter(x => !arr2.some(z => z === x));

/* Right trim (rtrim) */
string1 = string1.replace(/~+$/, '');
//$ marks the end of a string
// ~+$ means: all ~ characters at the end of a string

/* Замыкание в цикле */
for (var i = 0; i < links.length; i++) {
   (function(i) {
      links[i].onclick = function() {
         alert(i);
      }
   })(i);
}

/* localStorage */
localStorage.setItem('myKey', 'value');
localStorage.setItem('key', JSON.stringify(itemData)); 
user = JSON.parse(localStorage.getItem('key'));
localStorage.removeItem("myKey");

// Merge 2 arrays of objects
/*
var odd = [
    { name : "1", arr: "in odd" },
    { name : "3", arr: "in odd" }
];
var even = [
    { name : "1", arr: "in even" },
    { name : "2", arr: "in even" },
    { name : "4", arr: "in even" }
];
*/
function merge(a, b, prop){
  var reduced =  a.filter( aitem => ! b.find ( bitem => aitem[prop] === bitem[prop]) )
  return reduced.concat(b);
}
console.log(merge(odd, even, "name"));

// Order array of objects
items.sort((a, b) => (a.value > b.value) ? 1 : (a.value < b.value) ? -1 : 0);
items.sort((a, b) => a.value - b.value);

// Array of object to ['id', 'id2']
columns.filter(col => col.isPrimaryKey).map(col => col.name);

// Remove duplicates from array
var names = ["Mike","Matt","Nancy","Adam","Jenny","Nancy","Carl"];
uniqueArray = names.filter(function(item, pos) {
    return names.indexOf(item) == pos;
});
// Remove duplicates from an array of objects
columns = columns.filter((item, index) => {
  return index === columns.findIndex((x) => x.title === item.title);
});
// Unique array for dates
const uniqueDates = dates.filter((v, i, a) => a.findIndex(d => d.getTime() === v.getTime()) === i);

// remove from url
url.substring(0, url.lastIndexOf('/'));
window.location.href.split('#')[1];

// Move an array element from one array position to another
/*
let arr = [ 'a', 'b', 'c', 'd', 'e'];
arrayMove(arr,3,1); //["a", "d", "b", "c", "e"]
arr = [ 'a', 'b', 'c', 'd', 'e'];
arrayMove(arr,0,2); //["b", "c", "a", "d", "e"]
*/
function arrayMove(arr, fromIndex, toIndex) {
    var element = arr[fromIndex];
    arr.splice(fromIndex, 1);
    arr.splice(toIndex, 0, element);
}
// 2 способ
arr.splice(toIndex,0,arr.splice(fromIndex,1)[0]);

/* Проверка на пустой объект ECMA 5+: */
// because Object.keys(new Date()).length === 0;
Object.keys(obj).length === 0 && obj.constructor === Object
/* Проверка на пустой объект ECMA 7+: */
Object.entries(obj).length === 0 && obj.constructor === Object

/* Regex to split camel case */
"myCamelCaseString".split(/(?=[A-Z])/).map(s => s.toLowerCase());

/* Цикл по буквам */
var text = 'uololooo';
// With ES6
[...text].forEach(c => console.log(c))
// With the `of` operator
for (const c of text) {
    console.log(c)
}
// With ES5
for (var x = 0, c=''; c = text.charAt(x); x++) { 
    console.log(c); 
}
// ES5 without the for loop:
text.split('').forEach(function(c) {
    console.log(c);
});

// Каррирование
let add = x => y => x+y;
let increment = add(1);
let incrementBy2 = add(2);
console.log(increment(3)); // 4
console.log(incrementBy2(3)); // 5

// Quick Powers
console.log(2**3); // Result: 8
Math.pow(2, n);
2 << (n - 1); // 2 << 3 = 16 эквивалентно 2 ** 4 = 16
2 ** n;

// Float в целое число
console.log(23.9 | 0);  // Result: 23
console.log(-23.9 | 0); // Result: -23

// Убираем замыкающие числа
console.log(1553 / 10   | 0)  // Result: 155
console.log(1553 / 100  | 0)  // Result: 15
console.log(1553 / 1000 | 0)  // Result: 1

// focused element
elementWithFocus = document.activeElement;
expect(elementWithFocus).toBe(debugElement.nativeElement);
setInterval(function() { console.log(document.querySelector(":focus")); }, 1000);

// цветнык логи
console.log('%c Auth ', 
            'color: white; background-color: #2274A5', 
            'Login page rendered');
console.log('%c GraphQL ', 
            'color: white; background-color: #95B46A', 
            'Get user details');
console.log('%c Error ', 
            'color: white; background-color: #D33F49', 
            'Error getting user details');

// замерять время
let i = 0;
console.time('Execution time took');
while (i < 1000000) {
  i++;
}
console.timeEnd('Execution time took');

// Gradient. Color scale from 0% to 100%, rendering it from red to yellow to green
function perc2color(perc) {
  let r, g, b = 0;
  if (perc < 50) {
    r = 255;
    g = Math.round(5.1 * perc);
  }
  else {
    g = 255;
    r = Math.round(510 - 5.10 * perc);
  }
  const h = r * 0x10000 + g * 0x100 + b * 0x1;
  return '#' + ('000000' + h.toString(16)).slice(-6);
}

// go from red (0) to green (120)
percentageToColor(perc, maxHue = 120, minHue = 0) {
  const hue = (perc / 100) * (maxHue - minHue) + minHue;
  return `hsl(${hue}, 50%, 50%)`;
}

['VAL1', 'VAL2', 'VAL3'].reduce((a, b) => a + `,'` + b + `'`, '').substr(1);
// "'VAL1','VAL2','VAL3'"

// get every nth element in a given array
const everyNth = (arr, nth) => arr.filter((e, i) => i % nth === nth - 1);
