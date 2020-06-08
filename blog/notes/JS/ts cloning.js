class Example {
  constructor(public type: string) {
  }
}

class Customer {
  constructor(public name: string, public example: Example) {
  }
  greet() {
    return 'Hello ' + this.name;
  }
}

const customer = new Customer('David', new Example('DavidType'));

/*
Option 1: Spread

Properties: Yes
Methods: No
Deep Copy: No
*/
const clone = { ...customer };

console.log(clone.name + ' ' + clone.example.type); // David DavidType
// console.log(clone.greet()); // Not OK
clone.name = 'Steve';
clone.example.type = 'SteveType';
console.log(customer.name + ' ' + customer.example.type); // David SteveType

/*
Option 2: Object.assign

Properties: Yes
Methods: No
Deep Copy: No
*/
const clone = Object.assign({}, customer);

console.log(clone.name + ' ' + clone.example.type); // David DavidType
console.log(clone.greet()); // Not OK, although compiler won't spot it
clone.name = 'Steve';
clone.example.type = 'SteveType';
console.log(customer.name + ' ' + customer.example.type); // David SteveType

/*
Option 3: Object.create

Properties: Yes
Methods: Yes
Deep Copy: No
*/
const clone = Object.create(customer);

console.log(clone.name + ' ' + clone.example.type); // David DavidType
console.log(clone.greet()); // OK
clone.name = 'Steve';
clone.example.type = 'SteveType';
console.log(customer.name + ' ' + customer.example.type); // David SteveType

/*
Option 4: Deep Copy Function

Properties: Yes
Methods: No
Deep Copy: Yes
*/
export function deepCopy(obj) {
  let copy;
  if (null === obj || 'object' !== typeof obj) {
    return obj;
  }
  if (obj instanceof Date) {
    copy = new Date();
    copy.setTime(obj.getTime());
    return copy;
  }
  if (obj instanceof Array) {
    copy = [];
    for (let i = 0, len = obj.length; i < len; i++) {
      copy[i] = deepCopy(obj[i]);
    }
    return copy;
  }
  if (obj instanceof Object) {
    copy = {};
    for (const attr in obj) {
      if (obj.hasOwnProperty(attr)) {
        copy[attr] = deepCopy(obj[attr]);
      }
    }
    return copy;
  }
}

const clone = <Customer>deepCopy(customer);

console.log(clone.name + ' ' + clone.example.type); // David DavidType
// console.log(clone.greet()); // Not OK - not really a customer
clone.name = 'Steve';
clone.example.type = 'SteveType';
console.log(customer.name + ' ' + customer.example.type); // David DavidType
