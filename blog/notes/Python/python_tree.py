def build_tree(nodes):
    # create empty tree to fill
    tree = {}

    def build_tree_recursive(tree, parent, nodes):
        # find children
        children = [n for n in nodes if n['parent'] == parent]

        # build a subtree for each child
        for child in children:
            # start new subtree
            tree[child['name']] = {}

            # call recursively to build a subtree for current node
            build_tree_recursive(tree[child['name']], child['id'], nodes)

    # fill in tree starting with roots (those with no parent)
    build_tree_recursive(tree, None, nodes)

    return tree


def pop_list(nodes=None, parent=None, node_list=None):
    if parent is None:
        return node_list
    node_list.append([])
    for node in nodes:
        if node['parent'] == parent:
            node_list[-1].append(node)
        if node['id'] == parent:
            next_parent = node['parent']

    pop_list(nodes, next_parent, node_list)
    return node_list


def get_nodes(nodes, parent):
    d = {}
    d['name'] = parent
    children = [n for n in nodes if n['parent'] == parent]
    if children:
        d['children'] = [get_nodes(nodes, child['id']) for child in children]
    return d

nodes = [
    {'id': 1, 'parent': None, 'name': 'name1'},
    {'id': 2, 'parent': 1, 'name': 'name2'},
    {'id': 3, 'parent': 1, 'name': 'name3'},
    {'id': 4, 'parent': 2, 'name': 'name4'},
    {'id': 5, 'parent': 2, 'name': 'name5'},
    {'id': 6, 'parent': 5, 'name': 'name6'},
    {'id': 7, 'parent': 6, 'name': 'name7'},
    {'id': 8, 'parent': 3, 'name': 'name8'}
]
node_list = []
# prior parent_id
tree1 = pop_list(nodes, 5, node_list)
# prior id
tree2 = build_tree(nodes)
tree3 = get_nodes(nodes, None)

print(tree1)
print(tree2)
print(tree3)
