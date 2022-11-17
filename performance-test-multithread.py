"""
Quick script for testing the performance of the production server, by sending a configurable amount
of concurrent requests.
"""

TARGET_URL = "http://35.209.44.79/courses"  # "https://TomaRamos.App"
TIMEOUT_SECONDS = 10
DELAY_MILLISECONDS = 10
THREADS_COUNT = 60

import requests, threading, warnings, time

warnings.filterwarnings("ignore")  # ignoring complaints related to the SSL certificate

# SSL certificate check is disabled because throws "certificate verify failed: unable to get local
# issuer certificate" error
def testGet() -> None:
    local = threading.local()
    local.startTimestamp = time.time()
    local.req = requests.get(url=TARGET_URL, timeout=TIMEOUT_SECONDS, verify=False)
    local.elapsedTime = time.time() - local.startTimestamp
    print(
        "%s\t%.2f seconds\t%s"
        % (
            threading.currentThread().name,
            local.elapsedTime,
            "OK" if (local.req.status_code == 200) else "[!] Non-200",
        )
    )
    assert local.req.status_code == 200, "Unexpected requests status: %d" % local.req.status_code


if __name__ == "__main__":
    print("Will run %d threads with a request timeout of %d seconds" % (
        THREADS_COUNT, TIMEOUT_SECONDS
    ))

    for k in range(THREADS_COUNT):
        threading.Thread(target=testGet, name="Thread #%d" % k).start()
        time.sleep(float(DELAY_MILLISECONDS) / 1000.0)
