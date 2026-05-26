# QNX SDP Distribution Build

load("//:qnx_sdp.bzl", "qnx_sdp_distribution")

# Create the QNX SDP distribution from the patchset file
qnx_sdp_distribution(
    name = "qnx_sdp",
    patchset = "patchset-qnx803-virtio.plist",
    visibility = ["//visibility:public"],
)

# Package the SDP as a tarball for distribution (optional)
genrule(
    name = "qnx_sdp_tar",
    srcs = [":qnx_sdp"],
    outs = ["qnx803-sdp.tar.gz"],
    cmd = "tar -czf $@ -C $$(dirname $(location :qnx_sdp)) $$(basename $(location :qnx_sdp))",
    visibility = ["//visibility:public"],
)

# Create a filegroup that references the output directory
filegroup(
    name = "qnx_sdp_files",
    srcs = [":qnx_sdp"],
    visibility = ["//visibility:public"],
)

