var items = [1, 2, 3, 4, 5];
var fn = function asyncMultiplyBy2(v) { // sample async action
    return new Promise(resolve => setTimeout(() => resolve(v * 2), 100));
};
// map over forEach since it returns

var actions = items.map(fn); // run the function over all items.

// we now have a promises array and we want to wait for it

var results = Promise.all(actions); // pass array of promises
results.then(data => // or just .then(console.log)
    console.log(data) // [2, 4, 6, 8, 10]
);

Promise.all(items.map(function(item) {
    return new Promise(function(resolve, reject) {
        return setTimeout(() => resolve(item + 2), 100);
    });
})).then(function(data) {
    console.log(data);
});
