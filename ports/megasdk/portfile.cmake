vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO meganz/sdk
    REF "v${VERSION}"
    SHA512 0f33b52f017fdd738da3287153b2fd2a37c73b15a4005bb2a994e8d7af00f2314434c79bae1479db045362c332ff0caac6ae11e6790f365d34f0f520cf9c08d0
    HEAD_REF master
    PATCHES
        0001-fix-compiling-when-mediainfo-openssl-disabled.patch
        0002-fix-compiling-lib-when-sync-disabled.patch
        0003-fix-incorrect-libraries-linking-from-vcpkg.patch
        0004-fix-try-using-toolchain-file-variable-as-list.patch
        0005-set-vcpkg-root-to-bypass-later-checks.patch
        0006-partly-fix-compiling-tests-when-sync-disabled.patch
        0007-fix-cmake-build-interface-for-private-headers.patch
        0008-fix-build-interface-for-internal-ccronexpr-target.patch
        0009-added-install-targets.patch
        0010-replace-totally-incorrect-config-cmake-file.patch
        0011-added-detailed-output-of-selected-options.patch
)

vcpkg_find_acquire_program(SWIG)

# Documentation changes about default features with platform dependencies: https://github.com/microsoft/vcpkg-docs/pull/114

vcpkg_check_features(
    OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        java ENABLE_JAVA_BINDINGS
        qt ENABLE_QT_BINDINGS
        log-performance ENABLE_LOG_PERFORMANCE
        enable-drive-notifications ENABLE_DRIVE_NOTIFICATIONS
        enable-isolated-gfx ENABLE_ISOLATED_GFX
        enable-sync ENABLE_SYNC
        enable-chat ENABLE_CHAT
        use-openssl USE_OPENSSL
        use-mediainfo USE_MEDIAINFO 
        use-freeimage USE_FREEIMAGE
        use-ffmpeg USE_FFMPEG
        use-libuv USE_LIBUV
        use-pdfium USE_PDFIUM
        use-cares USE_C_ARES
        use-readline USE_READLINE
	    sdk-tests ENABLE_SDKLIB_TESTS
)

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
      -DENABLE_SDKLIB_EXAMPLES=OFF
      -DENABLE_SDKLIB_TESTS=OFF
      ${FEATURE_OPTIONS}
)

vcpkg_cmake_install()

vcpkg_cmake_config_fixup(
    PACKAGE_NAME "megasdk"
    CONFIG_PATH "lib/cmake/megasdk"
    TOOLS_PATH "bin"
)

vcpkg_copy_pdbs()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

file(INSTALL "${SOURCE_PATH}/LICENSE" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)
configure_file("${CMAKE_CURRENT_LIST_DIR}/usage" "${CURRENT_PACKAGES_DIR}/share/${PORT}/usage" COPYONLY)
