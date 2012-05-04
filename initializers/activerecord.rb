require 'active_record'
require 'uri'

unless ENV["SKIP_DATABASE"]
  db = URI.parse(URI.encode((ENV['DATABASE_URL'] || 'postgres://localhost/mydb').strip))

  ActiveRecord::Base.establish_connection(
    :adapter  => db.scheme == 'postgres' ? 'postgresql' : db.scheme,
    :host     => db.host,
    :username => db.user,
    :password => db.password,
    :database => db.path[1..-1],
    :encoding => 'utf8'
  )
end
