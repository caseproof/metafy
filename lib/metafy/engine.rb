require 'rails'
require 'active_record/base'
require 'metafy'

module Metafy
  class Engine < Rails::Engine
    config.autoload_paths += %W(#{config.root})
  end
end