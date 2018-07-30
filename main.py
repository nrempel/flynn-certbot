import os
import time
from subprocess import call

import schedule

FLYNN_TLS_PIN = os.environ.get("FLYNN_TLS_PIN")
FLYNN_CONTROLLER_KEY = os.environ.get("FLYNN_CONTROLLER_KEY")
FLYNN_CLUSTER_HOST = os.environ.get("FLYNN_CLUSTER_HOST")


def renew():
    call(
        [
            "/app/flynn",
            "cluster",
            "add",
            "-p",
            FLYNN_TLS_PIN,
            "default",
            FLYNN_CLUSTER_HOST,
            FLYNN_CONTROLLER_KEY,
        ]
    )


if __name__ == "__main__":
    renew()
    schedule.every(10).seconds.do(renew)
    while True:
        schedule.run_pending()
        time.sleep(1)
