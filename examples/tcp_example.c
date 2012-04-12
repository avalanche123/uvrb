#include <uv.h>
#include <stdio.h>
#include <stdlib.h>

#define RESPONSE \
  "HTTP/1.1 200 OK\r\n" \
  "Content-Type: text/plain\r\n" \
  "Content-Length: 12\r\n" \
  "\r\n" \
  "hello world\n"

static uv_buf_t resbuf;

void on_close(uv_handle_t* handle)
{
  free(handle);
}

void after_shutdown(uv_shutdown_t* req, int status) {
  free(req);
  uv_close((uv_handle_t*)req->handle, on_close);
}

void after_write(uv_write_t* req, int status) {
  uv_shutdown_t* shutdown_req = malloc(sizeof(uv_shutdown_t));

  free(req);
  // uv_shutdown(shutdown_req, req->handle, after_shutdown);
  uv_close((uv_handle_t*)req->handle, on_close);
}

void on_read(uv_stream_t* tcp, ssize_t nread, uv_buf_t buf)
{
  uv_write_t* write_req = malloc(sizeof(uv_write_t));

  uv_write(write_req, tcp, &resbuf, 1, after_write);
}

uv_buf_t on_alloc(uv_handle_t* client, size_t suggested_size)
{
  return uv_buf_init(malloc(suggested_size), suggested_size);
}

void on_connect(uv_stream_t* server, int status)
{
  uv_tcp_t* client = malloc(sizeof(uv_tcp_t));

  uv_tcp_init(uv_default_loop(), client);
  uv_accept(server, (uv_stream_t*) client);
  uv_read_start((uv_stream_t*) client, on_alloc, on_read);
}

int main(int argc, char* argv[])
{
  uv_tcp_t tcp;

  resbuf.base = RESPONSE;
  resbuf.len = sizeof(RESPONSE);

  uv_tcp_init(uv_default_loop(), &tcp);

  struct sockaddr_in address = uv_ip4_addr("0.0.0.0", 10000);
  uv_tcp_bind(&tcp, address);
  uv_listen((uv_stream_t*)&tcp, 128, on_connect);

  uv_run(uv_default_loop());
  uv_loop_delete(uv_default_loop());
}
