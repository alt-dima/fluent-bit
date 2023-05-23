# Custom build settings for Windows (MSVC)
#
# Not all plugins are supported on Windows yet. This file tweaks
# the build flags so that we can compile fluent-bit on it.

if(FLB_WINDOWS_DEFAULTS)
  message(STATUS "Overriding setttings with windows-setup.cmake")
  set(FLB_REGEX                 Yes)
  set(FLB_BACKTRACE              No)
  # LuaJIT does not currently support Windows ARM64 architecture so we disable it for now.
  # See also: https://github.com/LuaJIT/LuaJIT/issues/593
  if (CMAKE_SYSTEM_PROCESSOR MATCHES "^(ARM64|AARCH64)")
    set(FLB_LUAJIT               No)
  else()
    set(FLB_LUAJIT              Yes)
  endif()
  set(FLB_EXAMPLES              Yes)
  set(FLB_PARSER                Yes)
  set(FLB_TLS                   Yes)
  set(FLB_AWS                   Yes)
  set(FLB_HTTP_SERVER           Yes)
  set(FLB_METRICS               Yes)
  if (NOT FLB_LIBYAML_DIR)
    set(FLB_CONFIG_YAML         No)
  endif ()
  set(FLB_WASM                  No)
  set(FLB_WAMRC                 No)

  # INPUT plugins
  # =============
  set(FLB_IN_CPU                 No)
  set(FLB_IN_DISK                No)
  set(FLB_IN_EXEC                No)
  set(FLB_IN_EXEC_WASI           No)
  set(FLB_IN_FORWARD            Yes)
  set(FLB_IN_HEALTH              No)
  set(FLB_IN_HTTP               Yes)
  set(FLB_IN_MEM                 No)
  set(FLB_IN_KAFKA               No)
  set(FLB_IN_KMSG                No)
  set(FLB_IN_LIB                Yes)
  set(FLB_IN_RANDOM             Yes)
  set(FLB_IN_SERIAL              No)
  set(FLB_IN_STDIN               No)
  set(FLB_IN_SYSLOG             Yes)
  set(FLB_IN_TAIL               Yes)
  set(FLB_IN_TCP                Yes)
  set(FLB_IN_MQTT                No)
  set(FLB_IN_HEAD                No)
  set(FLB_IN_PROC                No)
  set(FLB_IN_SYSTEMD             No)
  set(FLB_IN_DUMMY              Yes)
  set(FLB_IN_NETIF               No)
  set(FLB_IN_WINLOG             Yes)
  set(FLB_IN_WINSTAT            Yes)
  set(FLB_IN_WINEVTLOG          Yes)
  set(FLB_IN_COLLECTD            No)
  set(FLB_IN_STATSD             Yes)
  set(FLB_IN_STORAGE_BACKLOG    Yes)
  set(FLB_IN_EMITTER            Yes)
  set(FLB_IN_PODMAN_METRICS      No)
  set(FLB_IN_ELASTICSEARCH      Yes)
  set(FLB_IN_SPLUNK             Yes)

  # OUTPUT plugins
  # ==============
  set(FLB_OUT_AZURE             Yes)
  set(FLB_OUT_AZURE_BLOB        Yes)
  set(FLB_OUT_AZURE_KUSTO       Yes)
  set(FLB_OUT_BIGQUERY           No)
  set(FLB_OUT_COUNTER           Yes)
  set(FLB_OUT_CHRONICLE         Yes)
  set(FLB_OUT_DATADOG           Yes)
  set(FLB_OUT_ES                Yes)
  set(FLB_OUT_EXIT               No)
  set(FLB_OUT_FORWARD           Yes)
  set(FLB_OUT_GELF              Yes)
  set(FLB_OUT_HTTP              Yes)
  set(FLB_OUT_INFLUXDB          Yes)
  set(FLB_OUT_NATS               No)
  set(FLB_OUT_PLOT               No)
  set(FLB_OUT_FILE              Yes)
  set(FLB_OUT_TD                 No)
  set(FLB_OUT_RETRY              No)
  set(FLB_OUT_SPLUNK            Yes)
  set(FLB_OUT_STACKDRIVER       Yes)
  set(FLB_OUT_STDOUT            Yes)
  set(FLB_OUT_LIB               Yes)
  set(FLB_OUT_NULL              Yes)
  set(FLB_OUT_FLOWCOUNTER       Yes)
  set(FLB_OUT_KAFKA              No)
  set(FLB_OUT_KAFKA_REST         No)
  set(FLB_OUT_CLOUDWATCH_LOGS   Yes)
  set(FLB_OUT_S3                Yes)
  set(FLB_OUT_KINESIS_FIREHOSE   Yes)
  set(FLB_OUT_KINESIS_STREAMS   Yes)

  # FILTER plugins
  # ==============
  set(FLB_FILTER_GREP           Yes)
  set(FLB_FILTER_MODIFY         Yes)
  set(FLB_FILTER_STDOUT         Yes)
  set(FLB_FILTER_PARSER         Yes)
  set(FLB_FILTER_KUBERNETES     Yes)
  set(FLB_FILTER_THROTTLE       Yes)
  set(FLB_FILTER_THROTTLE_SIZE  Yes)
  set(FLB_FILTER_NEST           Yes)
  set(FLB_FILTER_LUA            Yes)
  set(FLB_FILTER_RECORD_MODIFIER Yes)
  set(FLB_FILTER_REWRITE_TAG    Yes)
  set(FLB_FILTER_GEOIP2         Yes)
  set(FLB_FILTER_AWS            Yes)
  set(FLB_FILTER_ECS            Yes)
  set(FLB_FILTER_WASM           No)
endif()

# Search bison and flex executables
find_package(FLEX)
find_package(BISON)

if (NOT (${FLEX_FOUND} AND ${BISON_FOUND}))
  # The build will fail later if flex and bison are missing, so there's no
  # point attempting to continue. There's no test cover for windows builds
  # without FLB_PARSER anyway.
  message(FATAL_ERROR "flex and bison not found, see DEVELOPER_GUIDE.md")
endif()

if (MSVC)
  enable_language(RC)
  # use English language (0x409) in resource compiler
  set(rc_flags "/l0x409")
  set(CMAKE_RC_COMPILE_OBJECT "<CMAKE_RC_COMPILER> ${rc_flags} <DEFINES> /fo <OBJECT> <SOURCE>")
endif()

configure_file(
${CMAKE_CURRENT_SOURCE_DIR}/cmake/version.rc.in
${CMAKE_CURRENT_BINARY_DIR}/src/version.rc
@ONLY)
