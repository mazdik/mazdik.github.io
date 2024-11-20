const dirTree = require('./directory-tree');
const fs = require('fs');

const extensions = /\.(md|css|html|js|php|py|cs|sql|txt|jpg|png|sh|bat)$/;
const tree = dirTree('notes', { extensions, normalizePath: true });

fs.writeFile('data.json', JSON.stringify(tree), 'utf8', (err) => {
  if (err) return console.log(err);
  console.log('data.json created');
});
