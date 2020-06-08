var testModule = (function() {
    var basket = []; // приватная переменная

    function addItem(values) {
        basket.push(values);
    }

    function getItemCount() {
        return basket.length;
    }

    function getTotal() {
        var q = getItemCount(),
            p = 0;
        while (q--) {
            p += basket[q].price;
        }
        return p;
    }

    return { // методы доступные извне
        init: function() {
            addItem({ item: 'bread', price: 0.5 });
            addItem({ item: 'butter', price: 0.3 });
        },
        log: function() {
            console.log(getItemCount());
            console.log(getTotal());
        }
    }
}());

testModule.init();
testModule.log();
