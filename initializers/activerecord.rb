require 'active_record'
require 'uri'

unless Environment.skip_database
  db = URI.parse(URI.encode((Environment.database_url || 'postgres://localhost/mydb').strip))

  ActiveRecord::Base.establish_connection(
    :adapter  => db.scheme == 'postgres' ? 'postgresql' : db.scheme,
    :host     => db.host,
    :username => db.user,
    :password => db.password,
    :database => db.path[1..-1],
    :encoding => 'utf8'
  )
end
