import time
from subprocess import call

import schedule


def renew():
    call(
        [
            'L=./flynn && curl -sSL -A "`uname -sp`" https://dl.flynn.io/cli | zcat >$L && chmod +x $L'
        ]
    )


if __name__ == "__main__":
    renew()
    schedule.every(10).minutes.do(renew)
    while True:
        schedule.run_pending()
        time.sleep(1)
