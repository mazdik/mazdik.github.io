// Транспонирование (rows to columns)
function keyStringValues(row, keys) {
  return keys.map(x => row[x]).join(', ');
}

function pivot(rows, groupKeys, columnKey, valueKey, columnPrefix) {
  const res = {};
  rows.forEach(row => {
    key = keyStringValues(row, groupKeys);
    if (!res[key]) {
      res[key] = {};
      groupKeys.forEach(groupKey => {
        res[key][groupKey] = row[groupKey];
      });
    }
    res[key][columnPrefix + row[columnKey]] = row[valueKey];
  });
  return Object.values(res);
}

function addEmptyKeys(rows, fillValue = null) {
  const uniqueKeys = [...new Set(rows.map(x => Object.keys(x)).flat())]
  rows.forEach(row => {
    uniqueKeys.forEach(key => {
      if (!row.hasOwnProperty(key)) {
        row[key] = fillValue;
      }
    });
  });
  return rows;
}

const rows = [
  { well_id: 1001, dt: new Date(1900, 1, 1), param_id: 1, value: 10 },
  { well_id: 1001, dt: new Date(1900, 1, 1), param_id: 2, value: 20 },
  { well_id: 1001, dt: new Date(1900, 1, 1), param_id: 3, value: 30 },
  { well_id: 1001, dt: new Date(1900, 1, 2), param_id: 4, value: 40 },
  { well_id: 1001, dt: new Date(1900, 1, 2), param_id: 5, value: 50 },
  { well_id: 1002, dt: new Date(1900, 1, 1), param_id: 1, value: 11 },
  { well_id: 1002, dt: new Date(1900, 1, 1), param_id: 2, value: 21 },
  { well_id: 1002, dt: new Date(1900, 1, 1), param_id: 3, value: 31 },
  { well_id: 1002, dt: new Date(1900, 1, 2), param_id: 4, value: 41 },
  { well_id: 1002, dt: new Date(1900, 1, 2), param_id: 5, value: 51 }
];

let result = pivot(rows, ['well_id'], 'param_id', 'value', 'p');
console.log(result);
/*
{ well_id: 1001, p1: 10, p2: 20, p3: 30, p4: 40, p5: 50 }
{ well_id: 1002, p1: 11, p2: 21, p3: 31, p4: 41, p5: 51 }
*/

let result = pivot(rows, ['well_id', 'dt'], 'param_id', 'value', 'p');
console.log(result);
/*
{ well_id: 1001, dt: Feb 01 1900, p1: 10, p2: 20, p3: 30 }
{ well_id: 1001, dt: Feb 02 1900, p4: 40, p5: 50 }
{ well_id: 1002, dt: Feb 01 1900, p1: 11, p2: 21, p3: 31 }
{ well_id: 1002, dt: Feb 02 1900, p4: 41, p5: 51 }
*/

addEmptyKeys(result, null);
/*
{ well_id: 1001, dt: 'Feb 01 1900', p1: 10, p2: 20, p3: 30, p4: null, p5: null },
{ well_id: 1001, dt: 'Feb 02 1900', p4: 40, p5: 50, p1: null, p2: null, p3: null },
{ well_id: 1002, dt: 'Feb 01 1900', p1: 11, p2: 21, p3: 31, p4: null, p5: null },
{ well_id: 1002, dt: 'Feb 02 1900', p4: 41, p5: 51, p1: null, p2: null, p3: null }
*/
