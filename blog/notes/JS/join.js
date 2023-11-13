// Sample 1
let authors = [
    { id: 1, name: 'adam' },
    { id: 2, name: 'bob' },
    { id: 3, name: 'charlie' },
];
let books = [
    { author_id: 1, title: 'Coloring for beginners' },
    { author_id: 1, title: 'Advanced coloring' },
    { author_id: 2, title: '50 Hikes in New England' },
    { author_id: 2, title: '50 Hikes in Illinois' },
    { author_id: 3, title: 'String Theory for Dummies' },
];
// Left Outer Join
let map = {};
authors.forEach(x => map[x.id] = x);
books.forEach(x => x.author = map[x.author_id]);

// Inner Join
let map = {};
authors.forEach(x => map[x.id] = x);
let results = [];
books.forEach(x => {
    if (map[x.author_id]) {
        const copy = Object.assign({}, x);
        copy.author = map[x.author_id];
        results.push(copy);
    }
});


// Sample 2
let employee = [
    { name: 'Alice', department_id: 12 },
    { name: 'Bob', department_id: 13 },
    { name: 'Chris', department_id: 13 },
    { name: 'Dan', department_id: 14 },
    { name: 'Eve', department_id: null }
];
let department = [
    { department_id: 12, name: 'Sales' },
    { department_id: 13, name: 'Marketing' },
    { department_id: 14, name: 'Engineering' },
    { department_id: 15, name: 'Accounting' },
    { department_id: 16, name: 'Operations' }
];

// Left Outer Join
var results = [];
for (var i=0; i<employee.length; i++) {
    var found = false;
    for (var j=0; j<department.length; j++) {
        if (employee[i].department_id === department[j].department_id) {
            results.push({
                employee_name: employee[i].name, 
                employee_department_id: employee[i].department_id,
                department_id: department[j].department_id,
                department_name: department[j].name
            });
            found = true;
            break;
        }
    }
    if (found === false) {
        results.push({
            employee_name: employee[i].name, 
            employee_department_id: employee[i].department_id,
            department_id: null,
            department_name: null
        });    
    }
}

// Right Outer Join
var results = [];
for (var i=0; i<department.length; i++) {
    var found = false;
    for (var j=0; j<employee.length; j++) {
        if (employee[j].department_id === department[i].department_id) {
            results.push({
                employee_name: employee[j].name, 
                employee_department_id: employee[j].department_id,
                department_id: department[i].department_id,
                department_name: department[i].name
            });
            found = true;                
        }
    }
    if (found === false) {
        results.push({
            employee_name: null, 
            employee_department_id: null,
            department_id: department[i].department_id,
            department_name: department[i].name
        });    
    }
}


// remove duplicates
let duplicates = {};
for (var i=0; i< results.length; i++) {
    duplicates[JSON.stringify(results[i])] = results[i];
}
results = [];
for (var key in duplicates) {
    results.push(duplicates[key]);
}
