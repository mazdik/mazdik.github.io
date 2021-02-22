// Транспонирование (rows to columns)
const rows = [
  { well_id: 1001, param_id: 1, value: 10 },
  { well_id: 1001, param_id: 2, value: 20 },
  { well_id: 1001, param_id: 3, value: 30 },
  { well_id: 1001, param_id: 4, value: 40 },
  { well_id: 1001, param_id: 5, value: 50 },
  { well_id: 1002, param_id: 1, value: 11 },
  { well_id: 1002, param_id: 2, value: 21 },
  { well_id: 1002, param_id: 3, value: 31 },
  { well_id: 1002, param_id: 4, value: 41 },
  { well_id: 1002, param_id: 5, value: 51 }
];
const result = {};
rows.forEach(row => {
  if (!result[row.well_id]) {
    result[row.well_id] = { wellId: row.well_id };
  }
  const item = result[row.well_id];
  item['param' + row.param_id] = row.value;
});

console.log(result);
console.log(Object.values(result));
