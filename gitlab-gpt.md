docker run -it -e ACCESS_TOKEN=YWSHsP31ndsz_FZ6Vmvm -v $(pwd)/k6/config:/config -v $(pwd)/results:/results gitlab/gpt-data-generator --environment 1k.json


GPT Data Generator v1.4.0 - opinionated test data for the GitLab Performance Tool
The GPT Data Generator will inject the data into the specified group `gpt` with Public visibility on http://isbcloudrepo.tsmc.com. Note that this may take some time.
Do you want to proceed? [Y/N]
Y
Checking that GitLab environment 'http://isbcloudrepo.tsmc.com' is available, supported and that provided Access Token works...

GPT data generation failed:
HTTP::ConnectionError - failed to connect: getaddrinfo: Name does not resolve
 Traceback:["/usr/local/bundle/gems/http-5.2.0/lib/http/timeout/null.rb:16:in `initialize'", "/usr/local/bundle/gems/http-5.2.0/lib/http/timeout/null.rb:16:in `open'", "/usr/local/bundle/gems/http-5.2.0/lib/http/timeout/null.rb:16:in `connect'", "/usr/local/bundle/gems/http-5.2.0/lib/http/connection.rb:42:in `initialize'", "/usr/local/bundle/gems/http-5.2.0/lib/http/client.rb:70:in `new'", "/usr/local/bundle/gems/http-5.2.0/lib/http/client.rb:70:in `perform'", "/usr/local/bundle/gems/http-5.2.0/lib/http/client.rb:31:in `request'", "/usr/local/bundle/gems/http-5.2.0/lib/http/chainable.rb:20:in `get'", "/performance/lib/gpt_common.rb:22:in `call'", "/performance/lib/gpt_common.rb:22:in `make_http_request'", "/performance/lib/gpt_common.rb:63:in `check_gitlab_env_and_token'", "/performance/lib/gpt_test_data.rb:33:in `initialize'", "./bin/generate-gpt-data:121:in `new'", "./bin/generate-gpt-data:121:in `<main>'"]

█ Logs: /results/generate-gpt-data_isbcloudrepo.tsmc.com_2025-06-17_105530.log
tsaicch_tsmc.com:~/Desktop/performance$ docker run -it -e ACCESS_TOKEN=YWSHsP31ndsz_FZ6Vmvm --add-host isbcloudrepo.tsmc.com:172.28.229.28 -v $(pwd)/k6/config:/config -v $(pwd)/results:/results gitlab/gpt-data-generator --environment 1k.json
GPT Data Generator v1.4.0 - opinionated test data for the GitLab Performance Tool
The GPT Data Generator will inject the data into the specified group `gpt` with Public visibility on http://isbcloudrepo.tsmc.com. Note that this may take some time.
Do you want to proceed? [Y/N]
Y
Checking that GitLab environment 'http://isbcloudrepo.tsmc.com' is available, supported and that provided Access Token works...
Environment and Access Token check complete - URL: http://isbcloudrepo.tsmc.com, Version: 17.5.5-ee 0340daef062 {"enabled"=>false, "externalUrl"=>nil, "version"=>nil} true
