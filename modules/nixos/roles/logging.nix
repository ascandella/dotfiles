{ config, lib, ... }:

let
  cfg = config.my.logging;
in
with lib;
{
  options = {
    my.logging = {
      vector = {
        enable = mkEnableOption (mdDoc "enable vector quickwit") // {
          default = true;
        };
      };
      quickwit = {
        host = mkOption {
          type = types.str;
          default = "localhost";
        };
        index = mkOption {
          type = types.str;
          default = "otel-logs-v0-7";
        };
        port = mkOption {
          type = types.port;
          default = 7280;
        };
      };
    };
  };

  config = mkIf cfg.vector.enable {
    services = {
      vector = {
        enable = true;
        journaldAccess = true;
        settings = {
          sources = {
            journald = {
              type = "journald";
              exclude_units = [ "vector" ];
            };
          };
          transforms = {
            otel-journald = {
              type = "remap";
              inputs = [ "journald" ];
              source = ''
                .service_name = .SYSLOG_IDENTIFIER
                .timestamp_nanos = .__REALTIME_TIMESTAMP
                .resource_attributes.source_type = .source_type
                .resource_attributes.host.hostname = .host
                .resource_attributes.service.name = ._SYSTEMD_UNIT
                .resource_attributes.service.container_id = .CONTAINER_ID
                .attributes.syslog.procid = ._PID
                .attributes.syslog.facility = .SYSLOG_FACILITY
                .body = {
                  message = .message
                }
                .scope_name = .__SEQNUM
                .severity_text = if includes(["0", "1", "2", "3"], .PRIORITY) {
                  "ERROR"
                } else if .PRIORITY == "4" {
                  "WARN"
                } else if .PRIORITY == "7" {
                  "DEBUG"
                } else if includes(["6"], .PRIORITY) {
                  "INFO"
                } else {
                  "NOTICE"
                }

                del(.source_type)
                del(.host)
                del(.message)
                del(.PRIORITY)
                del(.CONTAINER_NAME)
                del(.CONTAINER_ID)
                del(.CONTAINER_ID_FULL)
                del(.SYSLOG_TIMESTAMP)
                del(.SYSLOG_IDENTIFIER)
                del(.SYSLOG_FACILITY)
                del(.SYSLOG_PID)
                del(.SESSION_ID)
                del(.INVOCATION_ID)
                del(.CODE_FILE)
                del(.CODE_FUNC)
                del(.CODE_LINE)
                del(._CMDLINE)
                del(._AUDIT_LOGINUID)
                del(.UNIT)
                del(._UID)
                del(._PID)
                del(._GID)
                del(._SELINUX_CONTEXT)
                del(._SYSTEMD_CGROUP)
                del(._SYSTEMD_SLICE)
                del(._SYSTEMD_UNIT)
                del(._SYSTEMD_INVOCATION_ID)
                del(._SYSTEMD_OWNER_UID)
                del(._SYSTEMD_USER_SLICE)
                del(._SYSTEMD_SESSION)
                del(.MESSAGE_ID)
                del(.LEADER)
                del(.TID)
                del(.JOB_ID)
                del(.JOB_TYPE)
                del(.JOB_RESULT)
                del(._COMM)
                del(._EXE)
                del(._MACHINE_ID)
                del(.__SEQNUM_ID)
                del(.__SEQNUM)
                del(._SOURCE_REALTIME_TIMESTAMP)
                del(._STREAM_ID)
                del(.USER_ID)
                del(.__MONOTONIC_TIMESTAMP)
                del(.__REALTIME_TIMESTAMP)
                del(._CAP_EFFECTIVE)
                del(._AUDIT_SESSION)
                del(._RUNTIME_SCOPE)
                del(._SOURCE_MONOTONIC_TIMESTAMP)
                del(._BOOT_ID)
                del(._TRANSPORT)
              '';
            };
          };
          sinks = {
            quickwit = {
              inputs = [ "otel-journald" ];
              type = "http";
              method = "post";
              encoding.codec = "json";
              framing.method = "newline_delimited";
              uri = "http://${cfg.quickwit.host}:${toString cfg.quickwit.port}/api/v1/${cfg.quickwit.index}/ingest";
            };
          };
        };
      };
    };
  };
}
