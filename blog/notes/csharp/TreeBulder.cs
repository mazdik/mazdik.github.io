using System;
using System.Collections.Generic;
using System.Linq;

namespace Itsk.Mer.Registry
{
    public class TreeNode
    {
       public string id;
       public string name;
       public object data;
       public List<TreeNode> children;
       public bool expanded;
       public bool leaf;
       public List<TreeNode> parent;
       public string icon;
    }

    public interface ITreeObject
    {
        string Id { get; set; }
        string ParentId { get; set; }
        string Name { get; set; }
    }

    public class TreeBulder
    {
        /// <summary>
        /// Дерево (быстрее чем рекурсивно Where(x => x.ParentId == parentId) 4сек против 1.5мин)
        /// </summary>
        public static List<TreeNode> RowsToTree<T>(List<T> rows, Func<T, TreeNode> createNode) where T : ITreeObject
        {
            var map = new Dictionary<string, TreeNode>();
            var roots = new List<TreeNode>();
            foreach (var row in rows)
            {
                var node = createNode(row);
                node.children = new List<TreeNode>();
                map.Add(row.Id, node);
            }
            foreach (var row in rows)
            {
                var node = map[row.Id];
                if (row.ParentId != null && map.ContainsKey(row.ParentId))
                {
                    map[row.ParentId].children.Add(node);
                } else
                {
                    roots.Add(node);
                }
            }
            return roots;
        }

        /// <summary>
        /// Дорожка вверх
        /// </summary>
        public static List<string> GetPath<T>(List<T> objects, string id, List<string> path) where T : ITreeObject
        {
            foreach (var obj in objects.Where(x => x.Id == id))
            {
                path.Add(obj.Id);
                if (obj.ParentId != null)
                {
                    return GetPath(objects, obj.ParentId, path);
                }
            }
            return path;
        }

        /// <summary>
        /// Уникальный порядок узлов для загрузки lazy loading
        /// </summary>
        public static List<string> SearchNodesPath<T>(List<T> objects, string nameSearch) where T : ITreeObject
        {
            var pathAll = new List<string>();
            if (!string.IsNullOrEmpty(nameSearch))
            {
                var findObjectIds = objects.Where(x => x.Name.ToLower().Contains(nameSearch.ToLower())).Select(x => x.Id).ToList();
                foreach (var id in findObjectIds)
                {
                    var path = GetPath(objects, id, new List<string>());
                    path.Reverse();
                    pathAll = (pathAll.Union(path)).ToList();
                }
            }
            return pathAll.Distinct().ToList();
        }

    }
}
