for (var i = 0; i < 4; i++) {
  setTimeout(() => console.log(i), 0);
}
/* Corrected code */
// 1. Change var to let, which is a block-level declaration
for (let i = 0; i < 4; i++) {
  setTimeout(() => console.log(i), 0);
}
// 2. Pass i to setTimeout as its third argument, so i is passed in as the argument in setTimeout's callback
for (var i = 0; i < 4; i++) {
  setTimeout((j) => console.log(j), 0, i);
}
// 3. Wrap the setTimeout in an Immediately-Invoked-Function-Expression and pass i into it
for (var i = 0; i < 4; i++) {
    (function(i) {
        setTimeout(() => console.log(i), 0);
    })(i);
}
