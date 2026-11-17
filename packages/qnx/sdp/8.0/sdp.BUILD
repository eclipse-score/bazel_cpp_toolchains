# *******************************************************************************
# Copyright (c) 2025 Contributors to the Eclipse Foundation
#
# See the NOTICE file(s) distributed with this work for additional
# information regarding copyright ownership.
#
# This program and the accompanying materials are made available under the
# terms of the Apache License Version 2.0 which is available at
# https://www.apache.org/licenses/LICENSE-2.0
#
# SPDX-License-Identifier: Apache-2.0
# *******************************************************************************
package(default_visibility = [
    "//visibility:public",
])

filegroup(
    name = "all_files",
    srcs = glob(["*/**/*"]),
)

filegroup(
    name = "empty",
)


# *******************************************************************************
# Target: x86_64
# *******************************************************************************
filegroup(
    name = "ar_x86_64",
    srcs = ["host/linux/x86_64/usr/bin/x86_64-pc-nto-qnx8.0.0-ar"],
)

filegroup(
    name = "as_x86_64",
    srcs = ["host/linux/x86_64/usr/bin/x86_64-pc-nto-qnx8.0.0-as"],
)

filegroup(
    name = "gcov_x86_64",
    srcs = ["host/linux/x86_64/usr/bin/x86_64-pc-nto-qnx8.0.0-gcov"],
)

filegroup(
    name = "ld_x86_64",
    srcs = ["host/linux/x86_64/usr/bin/x86_64-pc-nto-qnx8.0.0-ld"],
)

filegroup(
    name = "strip_x86_64",
    srcs = ["host/linux/x86_64/usr/bin/x86_64-pc-nto-qnx8.0.0-strip"],
)

filegroup(
    name = "mkifs_x86_64",
    srcs = ["host/linux/x86_64/usr/bin/mkifs"],
    data = glob(
        [
            "host/linux/x86_64/etc/qcc/**",
            "host/linux/x86_64/usr/bin/**",
            "host/linux/x86_64/usr/lib/gcc/**",
            "host/linux/x86_64/usr/lib/liblicense.so*",
            "target/qnx/etc/**",
            "target/qnx/sbin/**",
            "target/qnx/usr/**",
            "target/qnx/x86_64/boot/sys/**",
            "target/qnx/x86_64/usr/bin/**",
            "target/qnx/x86_64/usr/sbin/**",
            "target/qnx/x86_64/usr/lib/**",
            "target/qnx/x86_64/lib/**",
            "target/qnx/x86_64/bin/**",
            "target/qnx/x86_64/sbin/**",
            "target/qnx/x86_64/usr/libexec/**",
        ],
        exclude = [
            "target/qnx/usr/help/**",
            "target/qnx/aarch64le/boot/sys/libmod_timecc.a",
        ],
    ),
)

filegroup(
    name = "objdump_x86_64",
    srcs = ["host/linux/x86_64/usr/bin/ntox86_64-objdump"],
)

filegroup(
    name = "readelf_x86_64",
    srcs = ["host/linux/x86_64/usr/bin/ntox86_64-readelf"],
)

filegroup(
    name = "cxx_builtin_include_directories_x86_64",
    srcs = [
        "host/linux/x86_64/usr/lib/gcc/x86_64-pc-nto-qnx8.0.0/12.2.0/include",
        "target/qnx/usr/include",
        "target/qnx/usr/include/c++/v1",
        "target/qnx/usr/include/devs",
    ],
)

filegroup(
    name = "qcc_target_config_x86_64",
    srcs = glob([
        "host/linux/x86_64/etc/qcc/**/default",
        "host/linux/x86_64/etc/qcc/**/gcc_ntox86_64*",
    ]),
)

filegroup(
    name = "compiler_pieces_x86_64",
    srcs = glob([
        "host/linux/x86_64/usr/lib/gcc/x86_64-pc-nto-qnx8.0.0/12.2.0/cc1*",
        "host/linux/x86_64/usr/lib/gcc/x86_64-pc-nto-qnx8.0.0/12.2.0/include/**",
        "host/linux/x86_64/usr/lib/liblicense.so*",
    ]) + [
        ":qcc_target_config_x86_64",
    ],
)

filegroup(
    name = "linker_pieces_x86_64",
    srcs = glob([
        "host/linux/x86_64/usr/lib/gcc/x86_64-pc-nto-qnx8.0.0/12.2.0/**/*.o",
        "host/linux/x86_64/usr/lib/gcc/x86_64-pc-nto-qnx8.0.0/12.2.0/**/lib*",
        "host/linux/x86_64/usr/lib/gcc/x86_64-pc-nto-qnx8.0.0/12.2.0/lto*",
        "host/linux/x86_64/usr/lib/liblicense.so*",
        "target/qnx/x86_64/lib/*.o",
    ], exclude = ["**/*.sym"]) + [
        "host/linux/x86_64/usr/lib/gcc/x86_64-pc-nto-qnx8.0.0/12.2.0/collect2",
        ":qcc_target_config_x86_64",
    ],
)

filegroup(
    name = "target_libraries_x86_64",
    srcs = glob(
        [
            "target/qnx/x86_64/lib/gcc/12.2.0/libgomp.*",
            "target/qnx/x86_64/lib/libc.*",
            "target/qnx/x86_64/lib/libcatalog.*",
            "target/qnx/x86_64/lib/libm.*",
            "target/qnx/x86_64/lib/libqnxnoexcept.*",
            "target/qnx/x86_64/lib/libregex.*",
            "target/qnx/x86_64/lib/libsocket.*",
            "target/qnx/x86_64/lib/libbacktrace.*",
            "target/qnx/x86_64/usr/lib/libc++.*",
            "target/qnx/x86_64/usr/lib/libprofiling*",
            "target/qnx/x86_64/lib/libfsnotify.so*",
            "target/qnx/x86_64/lib/libslog2.so*",
            "target/qnx/x86_64/lib/libpci.so*",
            "target/qnx/x86_64/lib/libsecpolev.so*",
            "target/qnx/x86_64/lib/libsecpol.so*",
            "target/qnx/x86_64/usr/lib/libssl.so*",
            "target/qnx/x86_64/usr/lib/libcrypto.so*",
            "target/qnx/x86_64/usr/lib/libfscrypto.so*",
            "target/qnx/x86_64/usr/lib/libpcap*",
            "target/qnx/x86_64/usr/lib/libqcrypto.so*",
        ], 
        exclude = ["**/*.sym"],
    ) + [
            "target/qnx/x86_64/lib/gcc/12.2.0/libgcc_s.so",
            "target/qnx/x86_64/lib/libcS.a",
            "target/qnx/x86_64/lib/libmS.a",
            ":pci_solibs_x86_64",
            ":ssl_solibs_x86_64",
    ],
)

filegroup(
    name = "pci_solibs_x86_64",
    srcs = glob(
        ["target/qnx/x86_64/lib/libpci.so*"],
        exclude = [
            "**/*.sym",
        ],
    ),
)

filegroup(
    name = "ssl_solibs_x86_64",
    srcs = glob(
        [
            "target/qnx/x86_64/usr/lib/libssl.so*",
            "target/qnx/x86_64/usr/lib/libcrypto.so*",
        ],
        exclude = [
            "**/*.sym",
        ],
    ),
)

filegroup(
    name = "target_headers_x86_64",
    srcs = glob([
        "target/qnx/usr/include/x86/*.h", # For some reason we need this as well.
        "target/qnx/usr/include/x86_64/*.h",
        "target/qnx/usr/include/openssl/x86_64/*.h",
    ])+ [":target_headers"],
)

filegroup(
    name = "ar_files_x86_64",
    srcs = [":ar_x86_64"],
)

filegroup(
    name = "as_files_x86_64",
    srcs = [":as_x86_64"],
)

filegroup(
    name = "strip_files_x86_64",
    srcs = [":strip_x86_64"],
)

filegroup(
    name = "compiler_files_x86_64",
    srcs = [
        ":as_x86_64",
        ":compiler_pieces_x86_64",
        ":cc",
        ":cxx",
        ":target_headers_x86_64",
    ],
)

filegroup(
    name = "linker_files_x86_64",
    srcs = [
        ":cc",
        ":cxx",
        ":ld_x86_64",
        ":linker_pieces_x86_64",
        ":target_libraries_x86_64",
    ],
)

# *******************************************************************************
# Target: aarch64
# *******************************************************************************
filegroup(
    name = "ar_aarch64",
    srcs = ["host/linux/x86_64/usr/bin/aarch64-unknown-nto-qnx8.0.0-ar"],
)

filegroup(
    name = "as_aarch64",
    srcs = ["host/linux/x86_64/usr/bin/aarch64-unknown-nto-qnx8.0.0-as"],
)

filegroup(
    name = "gcov_aarch64",
    srcs = ["host/linux/x86_64/usr/bin/aarch64-unknown-nto-qnx8.0.0-gcov"],
)

filegroup(
    name = "ld_aarch64",
    srcs = ["host/linux/x86_64/usr/bin/aarch64-unknown-nto-qnx8.0.0-ld"],
)

filegroup(
    name = "strip_aarch64",
    srcs = ["host/linux/x86_64/usr/bin/aarch64-unknown-nto-qnx8.0.0-strip"],
)

filegroup(
    name = "mkifs_aarch64",
    srcs = ["host/linux/x86_64/usr/bin/mkifs"],
    data = glob(
        [
            "host/linux/x86_64/etc/qcc/**",
            "host/linux/x86_64/usr/bin/**",
            "host/linux/x86_64/usr/lib/gcc/**",
            "host/linux/x86_64/usr/lib/liblicense.so*",
            "target/qnx/etc/**",
            "target/qnx/sbin/**",
            "target/qnx/usr/**",
            "target/qnx/aarch64le/boot/sys/**",
            "target/qnx/aarch64le/usr/bin/**",
            "target/qnx/aarch64le/usr/sbin/**",
            "target/qnx/aarch64le/usr/lib/**",
            "target/qnx/aarch64le/lib/**",
            "target/qnx/aarch64le/bin/**",
            "target/qnx/aarch64le/sbin/**",
            "target/qnx/aarch64le/usr/libexec/**",
        ],
        exclude = [
            "target/qnx/usr/help/**",
            "target/qnx/aarch64le/boot/sys/libmod_timecc.a",
        ],
    ),
)

filegroup(
    name = "objdump_aarch64",
    srcs = ["host/linux/x86_64/usr/bin/ntoaarch64-objdump"],
)

filegroup(
    name = "readelf_aarch64",
    srcs = ["host/linux/x86_64/usr/bin/ntoaarch64-readelf"],
)

filegroup(
    name = "cxx_builtin_include_directories_aarch64",
    srcs = [
        "host/linux/x86_64/usr/lib/gcc/aarch64-unknown-nto-qnx8.0.0/12.2.0/include",
        "target/qnx/usr/include",
        "target/qnx/usr/include/c++/v1",
        "target/qnx/usr/include/devs",
    ],
)

filegroup(
    name = "qcc_target_config_aarch64",
    srcs = glob([
        "host/linux/x86_64/etc/qcc/**/default",
        "host/linux/x86_64/etc/qcc/**/gcc_ntoaarch64le*",
    ]),
)

filegroup(
    name = "compiler_pieces_aarch64",
    srcs = glob([
        "host/linux/x86_64/usr/lib/gcc/aarch64-unknown-nto-qnx8.0.0/12.2.0/cc1*",
        "host/linux/x86_64/usr/lib/gcc/aarch64-unknown-nto-qnx8.0.0/12.2.0/include/**",
        "host/linux/x86_64/usr/lib/liblicense.so*",
    ],
    exclude = ["**/*.sym"]) + [
        ":qcc_target_config_aarch64",
    ],
)

filegroup(
    name = "linker_pieces_aarch64",
    srcs = glob([
        "host/linux/x86_64/usr/lib/gcc/aarch64-unknown-nto-qnx8.0.0/12.2.0/**/*.o",
        "host/linux/x86_64/usr/lib/gcc/aarch64-unknown-nto-qnx8.0.0/12.2.0/**/lib*",
        "host/linux/x86_64/usr/lib/gcc/aarch64-unknown-nto-qnx8.0.0/12.2.0/lto*",
        "host/linux/x86_64/usr/lib/liblicense.so*",
        "target/qnx/aarch64le/lib/*.o",
    ],
    exclude = ["**/*.sym"]) + [
        "host/linux/x86_64/usr/lib/gcc/aarch64-unknown-nto-qnx8.0.0/12.2.0/collect2",
        ":qcc_target_config_aarch64",
    ],
)

filegroup(
    name = "target_libraries_aarch64",
    srcs = glob(
        [
            "target/qnx/aarch64le/lib/gcc/12.2.0/libgomp.*",
            "target/qnx/aarch64le/lib/libc.*",
            "target/qnx/aarch64le/lib/libcatalog.*",
            "target/qnx/aarch64le/lib/libm.*",
            "target/qnx/aarch64le/lib/libqnxnoexcept.*",
            "target/qnx/aarch64le/lib/libregex.*",
            "target/qnx/aarch64le/lib/libsocket.*",
            "target/qnx/aarch64le/lib/libbacktrace.*",
            "target/qnx/aarch64le/usr/lib/libc++.*",
            "target/qnx/aarch64le/usr/lib/libprofiling*",
            "target/qnx/aarch64le/lib/libfsnotify.so*",
            "target/qnx/aarch64le/lib/libslog2.so*",
            "target/qnx/aarch64le/lib/libpci.so*",
            "target/qnx/aarch64le/lib/libsecpolev.so*",
            "target/qnx/aarch64le/lib/libsecpol.so*",
            "target/qnx/aarch64le/usr/lib/libssl.so*",
            "target/qnx/aarch64le/usr/lib/libcrypto.so*",
            "target/qnx/aarch64le/usr/lib/libfscrypto.so*",
            "target/qnx/aarch64le/usr/lib/libpcap*",
            "target/qnx/aarch64le/usr/lib/libqcrypto.so*",
        ],
        exclude = ["**/*.sym"],
    ) + [
        "target/qnx/aarch64le/lib/gcc/12.2.0/libgcc_s.so",
        "target/qnx/aarch64le/lib/libcS.a",
        "target/qnx/aarch64le/lib/libmS.a",
        ":pci_solibs_aarch64",
        ":ssl_solibs_aarch64",
    ],
)

filegroup(
    name = "pci_solibs_aarch64",
    srcs = glob(
        ["target/qnx/aarch64le/lib/libpci.so*"],
        exclude = [
            "**/*.sym",
        ],
    ),
)
filegroup(
    name = "ssl_solibs_aarch64",
    srcs = glob(
        [
            "target/qnx/aarch64le/usr/lib/libssl.so*",
            "target/qnx/aarch64le/usr/lib/libcrypto.so*",
        ],
        exclude = [
            "**/*.sym",
        ],
    ),
)

filegroup(
    name = "target_headers_aarch64",
    srcs = glob([
        "target/qnx/usr/include/aarch64/*.h",
        "target/qnx/usr/include/openssl/aarch64le/*.h",
    ]) + [":target_headers"],
)

filegroup(
    name = "ar_files_aarch64",
    srcs = [":ar_aarch64"],
)

filegroup(
    name = "as_files_aarch64",
    srcs = [":as_aarch64"],
)

filegroup(
    name = "strip_files_aarch64",
    srcs = [":strip_aarch64"],
)

filegroup(
    name = "compiler_files_aarch64",
    srcs = [
        ":as_aarch64",
        ":compiler_pieces_aarch64",
        ":cc",
        ":cxx",
        ":target_headers_aarch64",
    ],
)

filegroup(
    name = "linker_files_aarch64",
    srcs = [
        ":cc",
        ":cxx",
        ":ld_aarch64",
        ":linker_pieces_aarch64",
        ":target_libraries_aarch64",
    ],
)

# *******************************************************************************
# Shared
# *******************************************************************************
filegroup(
    name = "cc",
    srcs = ["host/linux/x86_64/usr/bin/qcc"],
)

filegroup(
    name = "cxx",
    srcs = ["host/linux/x86_64/usr/bin/q++"],
)

filegroup(
    name = "qchecksec",
    srcs = ["host/linux/x86_64/usr/bin/qchecksec"],
)

filegroup(
    name = "mkifs",
    srcs = ["host/linux/x86_64/usr/bin/mkifs"],
)

filegroup(
    name = "host_all",
    srcs = glob(["host/linux/x86_64/**/*"]),
)

filegroup(
    name = "host_dir",
    srcs = ["host/linux/x86_64"],
)

filegroup(
    name = "target_all",
    srcs = glob(["target/qnx/**/*"]),
)

filegroup(
    name = "sysroot_dir",
    srcs = ["."],
)

filegroup(
    name = "target_dir",
    srcs = ["target/qnx"],
)

filegroup(
    name = "elfnote",
    srcs = ["host/linux/x86_64/usr/bin/elfnote"],
)

filegroup(
    name = "dumpifs",
    srcs = ["host/linux/x86_64/usr/bin/dumpifs"],
    data = glob(
        [
            "host/linux/x86_64/usr/lib/liblicense.so*",
        ],
    ),
)

filegroup(
    name = "traceprinter",
    srcs = ["host/linux/x86_64/usr/bin/traceprinter"],
)

filegroup(
    name = "use",
    srcs = ["host/linux/x86_64/usr/bin/use"],
    data = glob([
        "host/linux/x86_64/usr/lib/liblicense.so*",
    ]),
)

filegroup(
    name = "secpolcompile",
    srcs = [
        "host/linux/x86_64/usr/bin/secpolcompile",
    ],
    data = glob([
        "host/linux/x86_64/usr/lib/liblicense.so*",
    ]),
)

filegroup(
    name = "target_headers",
    srcs = glob([
        "target/qnx/usr/include/*.h",
        "target/qnx/usr/include/arpa/*.h",
        "target/qnx/usr/include/c++/v1/**",
        "target/qnx/usr/include/drvr/*.h",
        "target/qnx/usr/include/hw/**/*.h",
        "target/qnx/usr/include/net/**/*.h",
        "target/qnx/usr/include/netinet*/*.h",
        "target/qnx/usr/include/netipsec/*.h",
        "target/qnx/usr/include/openssl/*.h",
        "target/qnx/usr/include/secpol/*.h",
        "target/qnx/usr/include/sys/*.h",
        "target/qnx/usr/include/io-sock/**/*.h",
        "target/qnx/usr/include/pcap/*.h",
        "target/qnx/usr/include/pci/*.h",
        "target/qnx/usr/include/qcrypto/*.h",
        # FreeBSD deps
        "target/qnx/usr/include/devs/**/*.h",
    ]),
)

# *******************************************************************************
# TODO: Aliases that are pointing to all files as temp. solution.
# *******************************************************************************
alias(
    name = "coverage_files_x86_64",
    actual = ":all_files",
)

alias(
    name = "coverage_files_aarch64",
    actual = ":all_files",
)

# *******************************************************************************
# TODO: Aliases that are pointing to empty files as temp. solution.
# *******************************************************************************
alias(
    name = "dwp_files_x86_64",
    actual = ":empty",
)

alias(
    name = "objcopy_files_x86_64",
    actual = ":empty",
)

alias(
    name = "dwp_files_aarch64",
    actual = ":empty",
)

alias(
    name = "objcopy_files_aarch64",
    actual = ":empty",
)