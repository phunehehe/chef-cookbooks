%w{
  sqlite-aliases.cf
  sqlite-domains.cf
}.each do |postfix_tmpl|
  template  "/etc/postfix/#{postfix_tmpl}" do
    source "#{postfix_tmpl}.erb"
    owner 'postfix'
    mode '600'
    notifies :restart, "service[postfix]"
  end
end
