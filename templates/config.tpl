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
    %{ endfor ~}
    %{ endif ~}

    %{ for k, v in pagerduty_config }  
    - receiver: ${v.pagerduty_name}
      matchers:
        - severity=~"${v.severity}"
        - service=~"${v.pagerduty_name}"
      group_by: 
      - ${v.group_by}
    %{ endfor ~}

receivers:
  - name: default-receiver

  %{ for k, v in pagerduty_config }
  - name: ${v.pagerduty_name}
    pagerduty_configs:
    - send_resolved: true
      routing_key: ${v.pagerduty_key}
      url: https://events.pagerduty.com/v2/enqueue
      details:
        firing: '{{ template "pagerduty.default.instances" .Alerts.Firing }}'
        num_firing: '{{ .Alerts.Firing | len }}'
        num_resolved: '{{ .Alerts.Resolved | len }}'
        resolved: '{{ template "pagerduty.default.instances" .Alerts.Resolved }}'
      severity: '{{ if .CommonLabels.severity }}{{ .CommonLabels.severity | toLower
        }}{{ else }}critical{{ end }}'
      class: '{{ .CommonLabels.class }}'
      component: '{{ .CommonLabels.component }}'
      group: {{ if .CommonLabels.environment }}.{{ .CommonLabels.environment }}{{ end }}
      {{ if .CommonLabels.region }}.{{ .CommonLabels.region }}{{ end }}{{ if .CommonLabels.service }}.{{ .CommonLabels.service }}{{ end }}   
  %{ if enable_slack_integration == true }
  %{ for k, v in slack_config }    
    slack_configs:
     - api_url: ${v.slack_api_url}
       channel: '#${v.slack_channel}'
       title: '[{{ .Status }}{{ if eq .Status "firing" }}:{{ .Alerts.Firing | len }}{{ end }}] Monitoring Event Notification'
       send_resolved: true
       text: >- 
         <!channel> :warning::warning::warning:
         {{ range .Alerts }}
           *Environment:* production
           *Alert:* {{ .Annotations.summary }} - `{{ .Labels.severity }}`
           *Description:* {{ .Annotations.description }}
           *Details:*
           {{ range .Labels.SortedPairs }} • *{{ .Name }}:* `{{ .Value }}`
           {{ end }}
         {{ end }}      
  %{ endfor ~} 
  %{ endif ~}         
  %{ endfor ~}    
    


