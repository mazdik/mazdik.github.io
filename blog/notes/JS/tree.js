// flatten tree to tree
buildTree(list) {
  const map = {};
  const roots = [];
  for (let i = 0; i < list.length; i++) {
    map[list[i].id] = i; // initialize the map
    list[i].children = []; // initialize the children
  }
  for (let i = 0; i < list.length; i++) {
    const node = list[i];
    if (node.parentId !== 0) {
      // if you have dangling branches check that map[node.parentId] exists
      list[map[node.parentId]].children.push(node);
    } else {
      roots.push(node);
    }
  }
  return roots;
}

// Find tree node. Sample: getNode(nodes, 'name', name)
getNode(array, prop, value) {
  function findNode(a, i, o) {
    if (a[prop] === value) {
      node = o[i];
      return true;
    }
    return Array.isArray(a.children) && a.children.some(findNode);
  }
  let node;
  array.some(findNode);
  return node;
}