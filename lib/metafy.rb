module Metafy
  require 'metafy/engine' if defined?(Rails) && Rails::VERSION::MAJOR == 3
  require 'metafy/activerecord_methods' if defined?(Rails) && Rails::VERSION::MAJOR == 3
end
