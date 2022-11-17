"""
Quick script for testing the performance of the production server, by sending a configurable amount
of concurrent requests.
"""

TARGET_URL = "http://35.209.44.79/courses"  # "https://TomaRamos.App"
TIMEOUT_SECONDS = 10
COOLDOWN_MILLISECONDS = 10
THREADS_COUNT = 50

import requests, threading, warnings, time

warnings.filterwarnings("ignore")  # ignoring complaints related to the SSL certificate

# SSL certificate check is disabled because throws "certificate verify failed: unable to get local
# issuer certificate" error
def testGet(threadName) -> None:
    startTimestamp = time.time()
    req = requests.get(url=TARGET_URL, timeout=TIMEOUT_SECONDS, verify=False)
    elapsedTime = time.time() - startTimestamp
    print(
        "%s\t%.2f seconds\t%s"
        % (threadName, elapsedTime, "OK" if (req.status_code == 200) else "[!] Non-200")
    )
    assert req.status_code == 200, "Unexpected requests status: %d" % req.status_code


if __name__ == "__main__":
    for k in range(THREADS_COUNT):
        name = "Thread #%d" % k
        threading.Thread(target=testGet, args=[name], name=name).start()
        time.sleep(float(COOLDOWN_MILLISECONDS) / 1000.0)
