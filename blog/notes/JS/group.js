function keyStringValues(row: any, keys: any[]): string {
  return keys.map(x => row[x]).join(', ');
}

function groupAndSum(rows, groupKeys, sumKeys) {
  const res = {};
  rows.forEach(row => {
    key = keyStringValues(row, groupKeys);
    if (res[key]) {
      sumKeys.forEach(sumKey => {
        res[key][sumKey] += row[sumKey] || 0;
      });
    } else {
      res[key] = {};
      groupKeys.forEach(groupKey => {
        res[key][groupKey] = row[groupKey];
      });
      sumKeys.forEach(sumKey => {
        res[key][sumKey] = row[sumKey] || 0;
      });
    }
  });
  return Object.values(res);
}

const rows = [
 {paramId: 'test1', production: 4, losses: 2, count: 1},
 {paramId: 'test1', production: 6, losses: 3, count: 1},
 {paramId: 'test2', production: 1, losses: 0, count: 1},
 {paramId: 'test2', production: 2, losses: 1, count: 1},
 {paramId: 'test2', production: 3, losses: 1, count: 1},
];
console.log(groupAndSum(rows, ['paramId'], ['production', 'losses', 'count']));
/*
[
  {paramId: "test1", production: 10, losses: 5, count: 2},
  {paramId: "test2", production: 6, losses: 2, count: 3}
]
*/

// groupBy ver. 1
function groupBy(rows: any[], keys: any[]): any {
  const groups = {};
  rows.forEach(row => {
    const group = groupStringValues(row, keys);
    groups[group] = groups[group] || [];
    groups[group].push(row);
  });
  return groups;
}

// groupBy ver. 2
export function groupBy<T = any>(rows: T[], keyGetter: (item: T) => any): Map<any, T[]> {
  const map = new Map();
  rows.forEach((item) => {
    const key = keyGetter(item);
    if (!map.has(key)) {
      map.set(key, [item]);
    } else {
      map.get(key).push(item);
    }
  });
  return map;
}
groupBy<MeasureType>(measureTypes, x => x.chartGroupId);


function findMinMax(rows, field) {
  if (rows.length === 0) {
    return [null, null];
  }
  let min = rows[0][field];
  let max = min;
  for (let i = 1, len = rows.length; i < len; i++) {
    const v = field ? rows[i][field] : rows[i];
    min = (v < min) ? v : min;
    max = (v > max) ? v : max;
  }
  return [min, max];
}
