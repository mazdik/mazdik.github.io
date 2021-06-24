/* Точная проверка на число, */
function isNumeric(n) {
  return !isNaN(parseFloat(n)) && isFinite(n);
}

/* Поиск по значению объекта */
function findValue(o, value) {
    for (let prop in o) {
        if (o.hasOwnProperty(prop) && o[prop] === value) {
            return prop;
        }
    }
    return null;
}

/* Проверка на наличие слов исключений через запятую */
function postExcludes(description) {
    let isMatch = false;
    if (settings.exclude) {
        let excludes = settings.exclude.split(',');
        isMatch = excludes.some(function(exclude) {
            let regex = new RegExp(exclude.trim(), "i");
            return regex.test(description);
        });
    }
    return (isMatch);
}

/* Поиск объекта в массиве объектов и получение индекса в массиве */
findSelectedItemIndex():number {
  let obj = this.items.find(x => JSON.stringify(x) === JSON.stringify(this.selectedItem));
  let index = this.items.indexOf(obj);
  return index;
}

/* Element has scrollbars */
let div = document.getElementById('container_div_id');
let hasHorizontalScrollbar = div.scrollWidth > div.clientWidth;
let hasVerticalScrollbar = div.scrollHeight > div.clientHeight;

/* Ожидание появления элемента */
function waitForElementRender(elementSelector, callback) {
    var elements = document.querySelectorAll(elementSelector);

    if (elements && elements.length) {
        callback(elements);
    } else {
        setTimeout(function() {
            waitForElementRender(elementSelector, callback);
        }, 50);
    }
}
waitForElementRender('#add-button', function(elements) {
    $(elements).on('click', function(event) {
        openDialog();
    });
});

// Array filtering on multiple fields
/*
var arr = [
  { shape: 'square', color: 'red', used: 1, instances: 1 },
  { shape: 'square', color: 'red', used: 2, instances: 1 },
  { shape: 'circle', color: 'blue', used: 0, instances: 0 },
  { shape: 'square', color: 'blue', used: 4, instances: 4 },
  { shape: 'circle', color: 'red', used: 1, instances: 1 },
  { shape: 'circle', color: 'red', used: 1, instances: 0 },
  { shape: 'square', color: 'red', used: 4, instances: 4 },
  { shape: 'square', color: 'red', used: 2, instances: 2 }
];
globalFilter(arr, 'blue');
*/
 function globalFilter(data, filterValue) {
    if (filterValue) {
      return data.filter(item => Object.keys(item).map((key) => {
        return item[key].toString().toLowerCase().slice(0, filterValue.length) === filterValue.toLowerCase();
      }).includes(true));
    }
  }

// max z-index
export function maxZIndex() {
  return Array.from(document.querySelectorAll('body *'))
    .map(a => parseFloat(window.getComputedStyle(a).zIndex))
    .filter(a => !isNaN(a))
    .sort((a, b) => a - b)
    .pop();
}

// excel column number (25) to alphabet (AA)
function columnToLetter(column)
{
  var temp, letter = '';
  while (column > 0)
  {
    temp = (column - 1) % 26;
    letter = String.fromCharCode(temp + 65) + letter;
    column = (column - temp - 1) / 26;
  }
  return letter;
}
// excel column alphabet (AA) to number (25)
function letterToColumn(letter)
{
  var column = 0, length = letter.length;
  for (var i = 0; i < length; i++)
  {
    column += (letter.charCodeAt(i) - 64) * Math.pow(26, length - i - 1);
  }
  return column;
}
