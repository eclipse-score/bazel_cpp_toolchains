def compute_feature_lists(target_os):
    """Returns the flat known/enabled feature label lists for target_os.

    Unlike cc_feature_set (which groups features for requires_any_of/requires_all_of
    constraints and does not itself provide FeatureInfo), cc_toolchain_config's
    known_features/enabled_features attrs require every entry to individually
    provide FeatureInfo — so this returns plain lists of cc_feature labels rather
    than a single grouping target.

    Per-instance features (extra_compile_flags, extra_c_compile_flags,
    extra_cxx_compile_flags, extra_link_flags, sysroot_link_flags,
    compiler_library_search_paths) are baked into _LINUX_FEATURES/_QNX_FEATURES
    directly since their target names never change across toolchain instances —
    see templates/BUILD.template for where those targets get created.

    Args:
        target_os: "linux" or "qnx".

    Returns:
        (known_features, enabled_features) tuple of flat label lists.
    """
    if target_os == "linux":
        return linux_known_features(), linux_enabled_features()
    elif target_os == "qnx":
        return qnx_known_features(), qnx_enabled_features()
    else:
        fail("Unsupported target_os '{}', expected 'linux' or 'qnx'".format(target_os))
