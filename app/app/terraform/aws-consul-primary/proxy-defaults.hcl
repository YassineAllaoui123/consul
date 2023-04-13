Kind      = "proxy-defaults"
Name      = "global"
Namespace = "default"
Config {
  protocol = "http"
  envoy_extra_static_clusters_json = <<EOL
    {
      "connect_timeout": "3.000s",
      "dns_lookup_family": "V4_ONLY",
      "lb_policy": "ROUND_ROBIN",
      "load_assignment": {
          "cluster_name": "jaeger_zipkin",
          "endpoints": [
              {
                  "lb_endpoints": [
                      {
                          "endpoint": {
                              "address": {
                                  "socket_address": {
                                      "address": "127.0.0.1",
                                      "port_value": 9411,
                                      "protocol": "TCP"
                                  }
                              }
                          }
                      }
                  ]
              }
          ]
      },
      "name": "jaeger_zipkin",
      "type": "STRICT_DNS"
    }
  EOL
  envoy_tracing_json = <<EOL
    {
      "http": {
        "name": "envoy.tracers.zipkin",
        "typed_config": {
          "@type": "type.googleapis.com/envoy.config.trace.v3.ZipkinConfig",
          "collector_cluster": "jaeger_zipkin",
          "collector_endpoint": "/api/v2/spans",
          "collector_endpoint_version": "HTTP_JSON"
        }
      }
    }
  EOL
}
MeshGateway {
   Mode = "local"
}
