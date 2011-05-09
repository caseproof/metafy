module Metafy
  require 'metafy/engine' if defined?(Rails) && Rails::VERSION::MAJOR == 3
  require 'metafy/base' if defined?(Rails) && Rails::VERSION::MAJOR == 3
end
