if File.exist?(Rails.root.join('tmp', 'pids', 'server.pid'))
  File.delete(Rails.root.join('tmp', 'pids', 'server.pid'))
end