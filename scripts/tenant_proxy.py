#!/usr/bin/env python3
from http.server import BaseHTTPRequestHandler, HTTPServer
import json
import os


HOST = os.environ.get("TENANT_PROXY_HOST", "0.0.0.0")
PORT = int(os.environ.get("TENANT_PROXY_PORT", "18080"))
TENANT_LABEL = os.environ.get("TENANT_PROXY_LABEL", "Local backend")
TENANT_DOMAIN = os.environ.get("TENANT_PROXY_DOMAIN", "10.0.2.2")


class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        body = json.dumps(
            {
                "tenants": [
                    {
                        "label": TENANT_LABEL,
                        "domain": TENANT_DOMAIN,
                        "external": False,
                    }
                ]
            }
        ).encode("utf-8")
        self.send_response(200)
        self.send_header("content-type", "application/json")
        self.send_header("content-length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def log_message(self, *args):
        pass


if __name__ == "__main__":
    print(
        f"Serving tenant list on http://{HOST}:{PORT}/api/servers/ "
        f"with {TENANT_LABEL} -> {TENANT_DOMAIN}",
        flush=True,
    )
    HTTPServer((HOST, PORT), Handler).serve_forever()
