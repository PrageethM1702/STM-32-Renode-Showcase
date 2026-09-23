#include <sys/stat.h>
#include <errno.h>
#include <stdint.h>

extern uint8_t _end;
extern uint8_t _estack;

static uint8_t *heapEnd = &_end;

void *_sbrk(int increment)
{
    uint8_t *prevHeapEnd = heapEnd;

    if (heapEnd + increment > &_estack)
    {
        errno = ENOMEM;
        return (void *)-1;
    }

    heapEnd += increment;
    return prevHeapEnd;
}

int _close(int file)
{
    (void)file;
    return -1;
}

int _fstat(int file, struct stat *st)
{
    (void)file;
    st->st_mode = S_IFCHR;
    return 0;
}

int _isatty(int file)
{
    (void)file;
    return 1;
}

int _lseek(int file, int ptr, int dir)
{
    (void)file;
    (void)ptr;
    (void)dir;
    return 0;
}

int _read(int file, char *ptr, int len)
{
    (void)file;
    (void)ptr;
    (void)len;
    return 0;
}

int _write(int file, char *ptr, int len)
{
    (void)file;
    (void)ptr;
    (void)len;
    return len;
}

void _exit(int status)
{
    (void)status;
    for (;;)
    {
    }
}

int _kill(int pid, int sig)
{
    (void)pid;
    (void)sig;
    errno = EINVAL;
    return -1;
}

int _getpid(void)
{
    return 1;
}