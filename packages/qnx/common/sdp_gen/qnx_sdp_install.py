#!/usr/bin/env python3

import argparse
import netrc
import os
import subprocess
import sys
from pathlib import Path
from urllib.parse import urlparse


def parse_proxy(http_proxy: str) -> tuple[str, str]:
    if not http_proxy:
        return "", ""

    parsed = urlparse(http_proxy)

    proxy_host = parsed.hostname or ""
    proxy_port = str(parsed.port) if parsed.port else ""

    return proxy_host, proxy_port


def get_qnx_credentials() -> tuple[str, str]:
    user = os.environ.get("SCORE_QNX_USER")
    password = os.environ.get("SCORE_QNX_PASSWORD")

    if user and password:
        return user, password

    try:
        nrc = netrc.netrc()
        auth = nrc.authenticators("qnx.com")
        if auth:
            login, _, password = auth
            return login, password
    except Exception as exc:
        print(f"Failed reading credentials from .netrc: {exc}", file=sys.stderr)

    raise RuntimeError(
        "No QNX credentials found. Set SCORE_QNX_USER and SCORE_QNX_PASSWORD "
        "or add credentials for qnx.com to ~/.netrc."
    )


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

    print(
        f"Installing QNX SDP from patchset {patchset} "
        f"using {qnxsoftwarecenter_clt}"
    )
    print(f"Output directory: {install_dir}")

    install_dir.mkdir(parents=True, exist_ok=True)

    proxy_host, proxy_port = parse_proxy(os.environ.get("http_proxy", ""))

    qnx_user, qnx_password = get_qnx_credentials()

    cmd = [
        str(qnxsoftwarecenter_clt),
        "-proxy.host",
        proxy_host,
        "-proxy.port",
        proxy_port,
        "-myqnx.user",
        qnx_user,
        "-myqnx.password",
        qnx_password,
        "-importAndInstall",
        str(patchset),
        "-destination",
        str(install_dir),
    ]

    subprocess.run(cmd, check=True)

    print(f"QNX SDP distribution created successfully in {install_dir}")


if __name__ == "__main__":
    main()