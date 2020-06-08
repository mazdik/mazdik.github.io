from http.server import HTTPServer, BaseHTTPRequestHandler
import json


class S(BaseHTTPRequestHandler):
    def _set_headers(self):
        self.send_response(200)
        self.send_header('Content-type', 'application/json')
        self.end_headers()

    def _execute_request(self, content):
        self._set_headers()
        return content.encode("utf8")  # NOTE: must return a bytes object!

    def _json(self, message):
        content = json.dumps(message)
        return self._execute_request(content)

    def do_GET(self):
        self.wfile.write(self._json({'hello': 'world', 'received': 'ok'}))


def run(server_class=HTTPServer, handler_class=S, addr="localhost", port=8000):
    server_address = (addr, port)
    httpd = server_class(server_address, handler_class)

    print(f"Starting httpd server on {addr}:{port}")
    httpd.serve_forever()

run()
