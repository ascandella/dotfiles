{ config, lib, ... }:

let
  cfg = config.my.logging;
in
with lib;
{
  options = {
    my.logging = {
      vector = {
        enable = mkEnableOption (mdDoc "enable vector otel") // {
          default = true;
        };
      };
      otlp = {
        host = mkOption {
          type = types.str;
          default = "localhost";
        };
        port = mkOption {
          type = types.port;
          default = 4318;
        };
      };
    };
  };

  config = mkIf cfg.vector.enable {
    networking.firewall.interfaces.${config.services.aispace.wireguard.interface} = {
      allowedTCPPorts = [ 9598 ];
    };
    services = {
      vector = {
        enable = true;
        journaldAccess = true;
        settings = {
          sources = {
            journald = {
              type = "journald";
            };
            host-metrics = {
              type = "host_metrics";
              filesystem = {
                devices.excludes = [ "binfmt_misc" ];
                mountpoints.excludes = [
                  "*/proc/sys/fs/binfmt_misc"
                  "/run/*"
                  "/var/lib/*"
                ];
              };
            };
          };
          transforms = {
            otel-journald = {
              type = "remap";
              inputs = [ "journald" ];
              source = ''
                .body = del(.)
                .service_name = .body.SYSLOG_IDENTIFIER
                .timestamp_nanos = .body.__REALTIME_TIMESTAMP
                .resource_attributes = {}
                .resource_attributes.source_type = .body.source_type
                .resource_attributes.host = {}
                .resource_attributes.host.hostname = .body.host
                .resource_attributes.service = {}
                .resource_attributes.service.name = .body._SYSTEMD_UNIT
                .resource_attributes.service.container_id = .body.CONTAINER_ID
                .attributes = {}
                .attributes.syslog = {}
                .attributes.syslog.procid = .body._PID
                .attributes.syslog.facility = .body.SYSLOG_FACILITY
                .scope_name = .body.__SEQNUM
                .severity_text = if includes(["0", "1", "2", "3"], .body.PRIORITY) {
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
              '';
            };
          };
          sinks = {
            otlp = {
              inputs = [ "otel-journald" ];
              type = "opentelemetry";
              protocol = {
                type = "http";
                method = "post";
                encoding.codec = "json";
                framing.method = "newline_delimited";
                uri = "http://${cfg.otlp.host}:${toString cfg.otlp.port}/v1/logs";

              };
            };

            prometheus = {
              inputs = [ "host-metrics" ];
              type = "prometheus_exporter";
            };
          };
        };
      };
    };
  };
}
