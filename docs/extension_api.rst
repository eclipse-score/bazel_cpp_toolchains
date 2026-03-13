Extension API
=============

This page documents the Bazel *module extension* that provisions GCC toolchains and (optionally) related
software development packages (SDP archives) via ``http_archive``.

Scope
-----

The extension provides:

- A module extension named ``gcc``.
- Two tag classes:
  - ``toolchain``: declares a toolchain repository and its configuration.
  - ``sdp``: declares an archive (tarball) containing toolchain binaries and metadata needed for repository setup.

Where it lives
--------------

The implementation is a Starlark module extension defined in a ``.bzl`` file and exported as::

  gcc = module_extension(...)

Tag classes
-----------

toolchain
~~~~~~~~~

Defines a toolchain repository and how it should be provisioned (default package, custom SDP, or system toolchain).

**Required attributes**
- ``name`` (string): Toolchain repo name.
- ``target_cpu`` (string): Target CPU. Allowed: ``x86_64``, ``aarch64``.
- ``target_os`` (string): Target OS. Allowed: ``linux``, ``qnx``.

**Optional attributes**
- ``sdp_to_link`` (string): Name of the SDP package repo to link to this toolchain.
- ``use_default_package`` (bool): Use the default package from the version matrix.
- ``use_system_toolchain`` (bool): If true, do not download/link SDP archives (system toolchain mode).
- ``runtime_ecosystem`` (string): Runtime ecosystem identifier (default ``posix``).
- ``version`` (string): GCC toolchain version.
- ``license_info_url`` (string): URL of the license server (used for QNX flows).
- ``license_info_variable`` (string): Environment variable name for license info (used for QNX flows).
- ``sdp_version`` (string): SDP version (default ``8.0.0``; used for QNX SDP selection).
- ``license_path`` (string): Path to shared license file (default ``/opt/score_qnx/license/licenses``).
- ``extra_compile_flags`` (list of strings): Additional compiler flags.
- ``extra_link_flags`` (list of strings): Additional linker flags.

sdp
~~~

Defines an archive (tarball) that can be fetched via ``http_archive`` to provide toolchain binaries.

**Optional attributes**
- ``name`` (string): Package name. If empty, the extension may derive one depending on usage patterns.
- ``build_file`` (string): Path to the BUILD file used when creating the repository.
- ``url`` (string): Archive URL.
- ``strip_prefix`` (string): Prefix to strip when extracting.
- ``sha256`` (string): Archive checksum.

Behavior
--------

The extension gathers tags from the root module (non-root usage is rejected).

Provisioning logic summary:

- ``sdp`` tags are translated into ``http_archive(...)`` invocations.
- ``toolchain`` tags create a toolchain repository via ``gcc_toolchain(...)``.
- If ``use_system_toolchain`` is true, the extension skips SDP linking for that toolchain.
- If ``use_default_package`` is true, the extension derives an SDP archive from ``VERSION_MATRIX`` and links it.

Implementation reference
------------------------

If you keep the extension implementation in your repository, include it directly so documentation stays in sync:

.. literalinclude:: ../path/to/gcc_extension.bzl
   :language: python
   :linenos:
