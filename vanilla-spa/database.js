const fs = require("fs");
const sqlite3 = require('sqlite3').verbose();
const DATABASE = 'database.db'

function all(sql, params = []) {
  return new Promise((resolve, reject) => {
    const db = new sqlite3.Database(DATABASE);
    db.all(sql, params, (err, rows) => {
      (err) ? reject(err) : resolve(rows);
    });
    db.close();
  });
}

function run(sql, params = []) {
  return new Promise((resolve, reject) => {
    const db = new sqlite3.Database(DATABASE);
    db.run(sql, params, function(err) {
      (err) ? reject(err) : resolve(this.lastID);
    });
    db.close();
  });
}

function execute(db, sql, params = []) {
  return new Promise((resolve, reject) => {
    db.run(sql, params, function(err) {
      (err) ? reject(err) : resolve(this.changes);
    });
  });
}

async function getComments() {
  const sql = `select t.*, u.surname, u.name, u.middle_name, u.phone, u.email, i.city_name from comment t
    inner join user u on t.user_id = u.id
    left outer join city i on u.city_id = i.id`;
  return await all(sql);
}

async function getStat() {
  const sql = `select r.id, r.region_name, count(*) as cnt from comment t, user u, city c, region r
  where t.user_id = u.id and u.city_id = c.id and c.region_id = r.id
  group by r.id, r.region_name having count(t.comment) >= 1`;
  return await all(sql);
}

async function getStatCity(regionId) {
  const sql = `select c.id, c.city_name, count(*) as cnt from comment t, user u, city c, region r
  where t.user_id = u.id and u.city_id = c.id and c.region_id = r.id and r.id = ?
  group by c.id, c.city_name`;
  return await all(sql, [regionId]);
}

async function getRegions() {
  const sql = `select t.id, t.region_name from region t`;
  return await all(sql);
}

async function getCities(regionId) {
  const sql = `select t.id, t.city_name from city t where region_id = ?`;
  return await all(sql, [regionId]);
}

async function insertUser(surname, name, middle_name, city_id, phone, email) {
  const sql = `insert into user (surname, name, middle_name, city_id, phone, email) values (?,?,?,?,?,?)`;
  return await run(sql, [surname, name, middle_name, city_id, phone, email]);
}

async function insertComment(userId, comment) {
  const sql = `insert into comment (user_id, comment) values (?,?)`;
  return await run(sql, [userId, comment]);
}

async function deleteComment(commentId) {
  const sql = `delete from comment where id = ?`;
  return await run(sql, [commentId]);
}

async function initDb() {
  const dataSql = fs.readFileSync("./schema.sql").toString();
  const dataArr = dataSql.toString().split(";");

  const db = new sqlite3.Database(DATABASE);
  for (const sql of dataArr) {
    try {
      await execute(db, sql);
    } catch (e) {
      console.log(e);
    }
  }
  db.close();
}

async function test() {
  const result = await insertUser('sss', 'dddd', 'zzzz', 2, 5555, 'mail');
  console.log(result);
}

module.exports = { getComments, getStat, getStatCity, getRegions, getCities, insertUser, insertComment, deleteComment, initDb };
