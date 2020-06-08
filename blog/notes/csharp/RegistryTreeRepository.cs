using System;
using System.Collections.Generic;
using System.Linq;
using Dapper;
using Itsk.Mer.Interface.Database;

namespace Itsk.Mer.Registry
{
    public class RegistryObject: ITreeObject
    {
        public string Id { get; set; }
        public string ParentId { get; set; }
        public string Name { get; set; }
        public int ObjLevel { get; set; }
        public string Label { get; set; }
        public DateTime Ddate { get; set; }
        public string Code { get; set; }
        public int ChildrenCnt { get; set; }
    }

    public class RegistryTreeRepository
    {
        private readonly IMerDbConnection _connection;
        private const string FULL_LOADING = "FULL";

        public RegistryTreeRepository(IMerDbConnection connection)
        {
            _connection = connection ?? throw new ArgumentNullException(nameof(connection));
        }

        public List<TreeNode> GetTree(string categoryId, string typeLoading, string parentId)
        {
            var objects = GetObjects(categoryId, typeLoading, parentId);
            return TreeBulder.RowsToTree(objects, createNode);
        }

        /// <summary>
        /// Уникальный порядок узлов для загрузки lazy loading
        /// </summary>
        public List<string> SearchNodes(string categoryId, string nameSearch)
        {
            var objects = GetObjects(categoryId, FULL_LOADING, null);
            return TreeBulder.SearchNodesPath(objects, nameSearch);
        }

        private List<RegistryObject> GetObjects(string categoryId, string typeLoading, string parentId)
        {
            var dict = new Dictionary<string, string>();
            dict["org"] = RegistryTreeObjects.sqlOrg;
            dict["adm"] = RegistryTreeObjects.sqlAdm;
            dict["geo"] = RegistryTreeObjects.sqlGeo;
            dict["tech"] = RegistryTreeObjects.sqlTech;
            dict["wellb"] = RegistryTreeObjects.sqlWellb;

            if (!dict.ContainsKey(categoryId))
            {
                return new List<RegistryObject>();
            }
            using (var connection = _connection.GetConnection())
            {
                string sql;
                if (!string.IsNullOrEmpty(typeLoading) && typeLoading.ToUpper() == FULL_LOADING)
                {
                    sql = dict[categoryId];
                }
                else
                {
                    // LAZY LOADING
                    sql = "with W_TREE as (select * from (" + dict[categoryId] + ") V1)" +
                        " select V1.*, (select count(*) from W_TREE Z where Z.PARENT_ID = V1.ID) as CHILDREN_CNT from W_TREE V1";
                    if (parentId == null)
                    {
                        sql += " where V1.PARENT_ID is null";
                    }
                    else
                    {
                        sql += " where V1.PARENT_ID = :parentId";
                    }
                }
                return connection.Query<RegistryObject>(sql, new { parentId }).ToList();
            }
        }

        private static TreeNode createNode(RegistryObject row)
        {
            var icon = "tree-icon tree-file";
            if (row.ObjLevel == 1)
            {
                icon = "tree-icon tree-folder";
            }
            else if (row.ObjLevel > 100)
            {
                icon = "tree-icon tree-folder";
            }

            var node = new TreeNode
            {
                id = row.Id,
                name = row.Name,
                children = new List<TreeNode>(),
                leaf = row.ChildrenCnt == 0,
                data = new
                {
                    objLevel = row.ObjLevel,
                    tooltip = (!string.IsNullOrEmpty(row.Label)) ? row.Label + ": " + row.Name : row.Name,
                },
                icon = icon
            };
            return node;
        }
    }
}
