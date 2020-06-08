function groupAndSum(rows) {
  const result = [];
  rows.reduce((res, value) => {
    if (!res[value.fieldName]) {
      res[value.fieldName] = { fieldName: value.fieldName, oilProduction: 0, oilLosses: 0 , count: 0};
      result.push(res[value.fieldName]);
    }
    res[value.fieldName].oilProduction += value.oilProduction || 0;
    res[value.fieldName].oilLosses += value.oilLosses || 0;
    res[value.fieldName].count ++;
    return res;
  }, {});
  return result;
}

const rows = [
 {fieldName: 'test1', oilProduction: 4, oilLosses: 2},
 {fieldName: 'test1', oilProduction: 6, oilLosses: 3},
 {fieldName: 'test2', oilProduction: 1, oilLosses: 0},
 {fieldName: 'test2', oilProduction: 2, oilLosses: 1},
 {fieldName: 'test2', oilProduction: 3, oilLosses: 1},
];

console.log(groupAndSum(rows));

/*
[
  {fieldName: "test1", oilProduction: 10, oilLosses: 5, count: 2},
  {fieldName: "test2", oilProduction: 6, oilLosses: 2, count: 3}
]
*/
