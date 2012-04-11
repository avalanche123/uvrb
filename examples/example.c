# include <uv.h>
# include <stdio.h>

static int count = 0;

void close_cb(uv_handle_t* handle)
{
    // free(handle);
}

void timer_cb(uv_timer_t* timer, int status)
{
    puts("1");
    if (count >= 10) {
        // uv_unref(uv_default_loop());
        // uv_timer_stop(timer);
        uv_close((uv_handle_t*)timer, close_cb);
    }
    count++;
}

int main(int argc, char* argv[])
{
    uv_timer_t timer;
    printf("sizeof timer is %ld\n", sizeof(uv_timer_t));
    printf("sizeof tcp is %ld\n", sizeof(uv_tcp_t));
    printf("sizeof handle is %ld\n", sizeof(uv_handle_t));
    printf("sizeof tty is %ld\n", sizeof(uv_tty_t));
    printf("sizeof udp is %ld\n", sizeof(uv_udp_t));
    // printf("sizeof timer is %ld\n", sizeof(uv_timer_t));
    // printf("sizeof timer is %ld\n", sizeof(uv_timer_t));

    uv_timer_init(uv_default_loop(), &timer);
    uv_timer_start(&timer, timer_cb, 1, 1);
    uv_run(uv_default_loop());
    uv_loop_delete(uv_default_loop());
}