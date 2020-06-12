const http = require('http');
const url = require('url');

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

const handler1 = (request, response, query) => {
  if (Object.keys(query).length) {
    console.log(query);
  }
  sendResponse(response, { result: 'Hello World' }, 200);
};

const handler2 = (request, response, query) => {
  collectData(request, (formattedData) => {
    console.log(formattedData);
    sendResponse(response, { result: 'Success' }, 200);
  });
};

const routes = [
  { url: '/', method: 'GET', handler: handler1 },
  { url: '/test', method: 'GET', handler: handler1 },
  { url: '/test', method: 'POST', handler: handler2 }
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