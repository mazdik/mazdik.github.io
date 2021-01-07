const http = require('http');
const url = require('url');
const fs = require('fs');
const db = require('./database');

sendResponse = (response, data, statusCode) => {
  const headers = { 'Content-Type': 'application/json' };
  response.writeHead(statusCode, headers);
  response.end(JSON.stringify(data));
};

collectData = (request, callback) => {
  let data = '';
  request.on('data', (chunk) => {
    data += chunk;
  });
  request.on('end', () => {
    callback(data);
  });
};

const getIndex = (request, response, query) => {
  const content = fs.readFileSync('static/index.html');
  response.writeHead(200, { 'Content-Type': 'text/html' });
  response.end(content);
}

const getStaticFile = (request, response, query) => {
  const ext = request.url.split('.').pop();
  const contentType = ext === 'js' ? 'application/javascript' : (ext === 'css' ? 'text/css' : 'text/html');
  const content = fs.readFileSync('.' + request.url);
  response.writeHead(200, { 'Content-Type': contentType });
  response.end(content);
}

const getComments = async (request, response, query) => {
  const result = await db.getComments();
  sendResponse(response, result, 200);
};

const getStat = async (request, response, query) => {
  const result = await db.getStat();
  sendResponse(response, result, 200);
};

const getStatCity = async (request, response, query) => {
  const result = await db.getStatCity(query.regionId);
  sendResponse(response, result, 200);
};

const getRegions = async (request, response, query) => {
  const result = await db.getRegions();
  sendResponse(response, result, 200);
};

const getCities = async (request, response, query) => {
  const result = await db.getCities(query.regionId);
  sendResponse(response, result, 200);
};

const insertComment = async (request, response, query) => {
  collectData(request, async (str) => {
    const data = JSON.parse(str);
    const userId = await db.insertUser(data.surname, data.name, data.middle_name, data.city_id, data.phone, data.email);
    const result = await db.insertComment(userId, data.comment);
    sendResponse(response, result, 200);
  });
};

const deleteComment = async (request, response, query) => {
  const result = await db.deleteComment(query.commentId);
  sendResponse(response, result, 200);
};

const initDb = async (request, response, query) => {
  const result = await db.initDb();
  sendResponse(response, result, 200);
};

const routes = [
  { url: '/', method: 'GET', handler: getIndex },
  { url: '/getComments', method: 'GET', handler: getComments },
  { url: '/getStat', method: 'GET', handler: getStat },
  { url: '/getStatCity', method: 'GET', handler: getStatCity },
  { url: '/getRegions', method: 'GET', handler: getRegions },
  { url: '/getCities', method: 'GET', handler: getCities },
  { url: '/insertComment', method: 'POST', handler: insertComment },
  { url: '/deleteComment', method: 'DELETE', handler: deleteComment },
  { url: '/initDb', method: 'GET', handler: initDb },
  { url: '/static/app.css', method: 'GET', handler: getStaticFile },
  { url: '/static/app.js', method: 'GET', handler: getStaticFile },
];

const server = http.createServer((request, response) => {
  const parts = url.parse(request.url, true);
  const route = routes.find(x => x.url === parts.pathname && x.method === request.method);

  if (route) {
    route.handler(request, response, parts.query);
  } else {
    sendResponse(response, "Not found", 404);
  }
});
server.listen(8080);

/*
fetch('/test', {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json;charset=utf-8'
  },
  body: JSON.stringify({ name: 'John', surname: 'Smith' })
}).then(res=>res.json())
  .then(res => console.log(res));
*/