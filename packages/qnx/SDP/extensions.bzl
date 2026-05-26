"""Bazel module extension for QNX repositories."""

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_file")
load("//:qnx_install.bzl", "qnx_software_center_repository")

def _qnx_repositories_impl(module_ctx):
    """Implementation of the QNX repositories extension."""

    # Download the QNX installer
    http_file(
        name = "qnx_installer",
        url = "https://www.qnx.com/download/download/79441/qnx-setup-2.0.4-202501021438-linux.run",
        executable = True,
        downloaded_file_path = "qnx-setup-2.0.4-202501021438-linux.run",
    )

    # Create the QNX Software Center repository
    qnx_software_center_repository(
        name = "qnx_software_center",
        installer = "@qnx_installer//file:qnx-setup-2.0.4-202501021438-linux.run",
    )

qnx_repositories = module_extension(
    implementation = _qnx_repositories_impl,
)
