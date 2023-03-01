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
        - severity=${v.severity}
        - service=${v.pagerduty_name}
      group_by: 
      - ${v.group_by}
    %{ endfor ~}

receivers:
  - name: default-receiver

  %{ for k, v in pagerduty_config }
  - name: ${v.pagerduty_name}
    pagerduty_configs:
    - routing_key: ${v.pagerduty_key}
	    severity: ${v.severity}  
      details:
        container: "{{ range .Alerts }}{{ .Labels.container }}{{ end }}"
        region: "{{ range .Alerts }}{{ .Labels.region }}{{ end }}"
        severity: "{{ range .Alerts }}{{ .Labels.severity }}{{ end }}"
        ownership: "{{ range .Alerts }}{{ .Annotations.ownership }}{{ end }}"
        summary: "{{ range .Alerts }}{{ .Annotations.summary }}{{ end }}"
        runbook_url: "{{ range .Alerts }}{{ .Annotations.runbook_url }}{{ end }}"
        description: "{{ range .Alerts }}{{ .Annotations.description }}{{ end }}"    
  %{ if enable_slack_integration == true }
  %{ for k, v in slack_config }    
    slack_configs:
     - api_url: ${v.slack_api_url}
       channel: '#${v.slack_channel}'
       send_resolved: true  
       title: "{{ range .Alerts }}{{ .Annotations.summary }}\n{{ end }}"
       text: "{{ range .Alerts }}{{ .Annotations.description }}\n{{ end }}"       
  %{ endfor ~} 
  %{ endif ~}         
  %{ endfor ~}    
    


