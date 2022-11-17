"""
threadCount=60
for k in {1..${threadCount}}; do python3 performance-test-single.py & done
"""

TARGET_URL = "http://35.209.44.79/courses"
TIMEOUT_SECONDS = 5

import requests, threading, warnings, time

warnings.filterwarnings("ignore")  # ignoring complaints related to the SSL certificate

# SSL certificate check is disabled because throws "certificate verify failed: unable to get local
# issuer certificate" error
def testGet() -> None:
    startTimestamp = time.time()
    req = requests.get(url=TARGET_URL, timeout=TIMEOUT_SECONDS, verify=False)
    elapsedTime = time.time() - startTimestamp
    print(
        "%s\t%.2f seconds\t%s"
        % (
            threading.currentThread().name,
            elapsedTime,
            "OK" if (req.status_code == 200) else "[!] Non-200",
        )
    )
    assert req.status_code == 200, "Unexpected requests status: %d" % req.status_code


if __name__ == "__main__":
    testGet()
