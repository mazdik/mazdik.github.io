const arr = [1, 2, 3];
const waitFor = (ms) => new Promise(r => setTimeout(r, ms));

// без порядка
arr.forEach(async (num) => {
  const sec = Math.random() * (2000 - 1000) + 1000;
  await waitFor(sec);
  console.log(num);
});

// без порядка
await arr.forEach(async (num) => {
  const sec = Math.random() * (2000 - 1000) + 1000;
  await waitFor(sec);
  console.log(num);
});

// без порядка
await Promise.all(arr.map(async (num) => {
  const sec = Math.random() * (2000 - 1000) + 1000;
  await waitFor(sec);
  console.log(num);
}));

// по порядку
for (const num of arr) {
  const sec = Math.random() * (2000 - 1000) + 1000;
  await waitFor(sec);
  console.log(num);
}
