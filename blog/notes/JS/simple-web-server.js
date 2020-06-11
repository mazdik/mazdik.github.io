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

const handler1 = (request, response) => {
  sendResponse(response, { result: 'Hello World' }, 200);
};

const handler2 = (request, response) => {
  collectData(request, (formattedData) => {
    console.log(formattedData);
    sendResponse(response, { result: 'Success' }, 200);
  });
};

const routes = {
  '/': { method: 'GET', handler: handler1 },
  '/test': { method: 'POST', handler: handler2 },
};

const server = http.createServer((request, response) => {
  const parts = url.parse(request.url);
  const route = routes[parts.pathname];

  if (route && route.method === request.method) {
    route.handler(request, response);
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