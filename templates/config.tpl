global: {}

templates:
  - '/etc/alertmanager/*.tmpl'
  
route:

  group_wait: 10s
  group_interval: 5m
  receiver: 'default-receiver'
  repeat_interval: 3h

  routes:
    %{ if enable_slack_integration == true }
    %{ for k, v in slack_config }  
    - receiver: ${v.slack_name}
      match_re:
        severity: ${v.severity}
      group_wait: ${v.group_wait}
      continue: ${v.continue}
      repeat_interval: ${v.repeat_interval}
      group_interval: ${v.group_interval}
      time:
        days: [monday, tuesday, thursday, friday]
        start: 17:00
        end: 08:00
    %{ endfor ~}
    %{ endif ~}

    %{ for k, v in pagerduty_config }  
    - receiver: ${v.pagerduty_name}
      matchers:
        - severity=~"${v.severity}"
        - service=~"${v.pagerduty_name}"
      group_by: [...]
    %{ endfor ~}

receivers:
  - name: default-receiver

  %{ for k, v in pagerduty_config }
  - name: ${v.pagerduty_name}
    pagerduty_configs:
    - send_resolved: true
      routing_key: ${v.pagerduty_key}
      url: https://events.pagerduty.com/v2/enqueue
      client: '{{ template "pagerduty.default.client" . }}'
      client_url: '{{ template "pagerduty.default.clientURL" . }}'
      description: '[{{ .CommonLabels.cliente }}] {{ .CommonAnnotations.description }}'
      details:
        firing: '{{ template "pagerduty.default.instances" .Alerts.Firing }}'
        num_firing: '{{ .Alerts.Firing | len }}'
        num_resolved: '{{ .Alerts.Resolved | len }}'
        resolved: '{{ template "pagerduty.default.instances" .Alerts.Resolved }}'
        cliente: '{{ .CommonLabels.cliente }}'
      severity: '{{ if .CommonLabels.severity }}{{ .CommonLabels.severity | toLower}}{{ else }}critical{{ end }}'
  %{ if enable_slack_integration == true }
  %{ for k, v in slack_config }    
    slack_configs:
     - api_url: ${v.slack_api_url}
       channel: '#${v.slack_channel}'
       icon_url: https://coralogix.com/wp-content/uploads/2021/02/Prometheus.png
       title: '[{{ .Status }}{{ if eq .Status "firing" }}:{{ .Alerts.Firing | len }}{{ end }}] Monitoring Event Notification'
       send_resolved: true
       text: >- 
         <!channel> :warning::warning::warning:
         {{ range .Alerts }}
           *Alert:* {{ .Annotations.summary }} - `{{ .Labels.severity }}`
           *Description:* {{ .Annotations.description }}
           *Details:*
           {{ range .Labels.SortedPairs }} • *{{ .Name }}:* `{{ .Value }}`
           {{ end }}
         {{ end }}      
  %{ endfor ~} 
  %{ endif ~}         
  %{ endfor ~}    
    

