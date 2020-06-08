// filter is equivalent to Where
let youngsters2 = people.filter(p => p.age < 30);

// map is equivalent to Select
let names2 = people.map(i => i.name);

// every is equivalent to All
let allUnder402 = people.every(i => i < 40);

// some is equivalent to Any
let anyUnder302 = people.some(p => p.age < 30);

// reduce is "kinda" equivalent to Aggregate (and also can be used to Sum)
let aggregate2 = people.reduce((a,b) => ({name:'', age: a.age + b.age}));

// sort is "kinda" like OrderBy (but it sorts the array in place - eek!)
people.sort((a,b) => a.name > b.name ? 1 : 0);
