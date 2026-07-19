#include <stdio.h>
#include <unistd.h>

// Delay applied only in mock mode so that locally-canned responses render
// with a visible per-chunk typing effect.  Real API calls are naturally
// paced by network latency and do not need artificial delays.
#define TYPEWRITER_DELAY_US 50000

// `is_mock` is 1 when running with a canned mock_body (no real API call);
// only then do we sleep between chunks to simulate a typewriter.
void moonbit_print_flush(const char* data, int len, int is_mock) {
    if (len > 0) {
        fwrite(data, 1, (size_t)len, stdout);
        fflush(stdout);
        if (is_mock) {
            usleep(TYPEWRITER_DELAY_US);
        }
    }
}
