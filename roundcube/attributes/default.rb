::Chef::Node.send(:include, Opscode::OpenSSL::Password)


default[:roundcube][:max_attachment_size] = '10M'


# Roundcube default is ISO-8859-1, but UTF-8 should be better
default[:roundcube][:default_charset] = 'UTF-8'

# Roundcube default lets the user specify the IMAP server, but with
# auto_create_user enabled (the default) this lets users use the Roundcube
# installation with all hosts, which is a little chaotic.
default[:roundcube][:default_host] = 'localhost'

# Roundcube default is a hard-coded string
default[:roundcube][:des_key] = secure_password[0..23]

# Roundcube default is 300 seconds, not very useful
default[:roundcube][:draft_autosave] = 60

# HTML editor is nice
default[:roundcube][:htmleditor] = true

# Roundcube default maintains backward compatibility with RFC 2047, a standard
# now obsoleted
default[:roundcube][:mime_param_folding] = 0

# Preview pane is nice
default[:roundcube][:preview_pane] = true

# Roundcube default is empty
default[:roundcube][:smtp_pass] = '%p'
default[:roundcube][:smtp_server] = 'localhost'
default[:roundcube][:smtp_user] = '%u'

# These use the same default as Roundcube
default[:roundcube][:addressbook_pagesize] = 50
default[:roundcube][:autoexpand_threads] = 0
default[:roundcube][:check_all_folders] = false
default[:roundcube][:default_port] = 143
default[:roundcube][:enable_spellcheck] = true
default[:roundcube][:imap_auth_type] = ''
default[:roundcube][:imap_cache] = ''
default[:roundcube][:imap_force_caps] = false
default[:roundcube][:ip_check] = false
default[:roundcube][:log_driver] = 'file'
default[:roundcube][:mail_pagesize] = 50
default[:roundcube][:managesieve_auth_type] = ''
default[:roundcube][:mdn_requests] = 0
default[:roundcube][:messages_cache] = false
default[:roundcube][:plugins] = []
default[:roundcube][:prefer_html] = true
default[:roundcube][:read_when_deleted] = true
default[:roundcube][:refresh_interval] = 60
default[:roundcube][:session_lifetime] = 10
default[:roundcube][:smtp_auth_type] = ''
