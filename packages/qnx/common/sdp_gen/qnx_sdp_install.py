#!/usr/bin/env python3

import argparse
import os
import subprocess
from pathlib import Path
from urllib.parse import urlparse


def parse_proxy(http_proxy: str) -> tuple[str, str]:
    if not http_proxy:
        return "", ""

    parsed = urlparse(http_proxy)

    proxy_host = parsed.hostname or ""
    proxy_port = str(parsed.port) if parsed.port else ""

    return proxy_host, proxy_port


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Install QNX SDP from a patchset using qnxsoftwarecenter_clt."
    )

    parser.add_argument(
        "--qnxsoftwarecenter-clt",
        required=True,
        help="Path to qnxsoftwarecenter_clt executable.",
    )

    parser.add_argument(
        "--patchset",
        required=True,
        help="Path to QNX patchset/package list.",
    )

    parser.add_argument(
        "--install-dir",
        required=True,
        help="Output installation directory.",
    )

    args = parser.parse_args()

    qnxsoftwarecenter_clt = Path(args.qnxsoftwarecenter_clt)
    patchset = Path(args.patchset)
    install_dir = Path(args.install_dir)

    install_dir.mkdir(parents=True, exist_ok=True)

    http_proxy = os.environ.get("http_proxy", "")
    proxy_host, proxy_port = parse_proxy(http_proxy)

    score_qnx_user = os.environ["SCORE_QNX_USER"]
    score_qnx_password = os.environ["SCORE_QNX_PASSWORD"]

    cmd = [
        str(qnxsoftwarecenter_clt),
        "-proxy.host",
        proxy_host,
        "-proxy.port",
        proxy_port,
        "-myqnx.user",
        score_qnx_user,
        "-myqnx.password",
        score_qnx_password,
        "-importAndInstall",
        str(patchset),
        "-destination",
        str(install_dir),
    ]

    subprocess.run(cmd, check=True)

    print(f"QNX SDP distribution created successfully in {install_dir}")


if __name__ == "__main__":
    main()