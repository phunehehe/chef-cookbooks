include_recipe 'postfix::vanilla'

%w{ libsasl2-2 sasl2-bin }.each do |p|
    package p
end

directory '/var/spool/postfix/var/run/saslauthd' do
    recursive true
end

link '/var/spool/postfix/var/run/saslauthd/mux' do
    to '/run/saslauthd/mux'
end

service 'saslauthd' do
    action [:enable, :start]
end

template '/etc/default/saslauthd' do
    mode '644'
    notifies :restart, 'service[saslauthd]'
end

template '/etc/postfix/sasl/smtpd.conf' do
    mode '644'
    notifies :restart, 'service[postfix]'
end
