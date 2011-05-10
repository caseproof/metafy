require 'metafy/base'

# Adds the metafy method in ActiveRecord::Base, which can be used to define the metafied objects.
class << ActiveRecord::Base
  def metafied?
    @metafied || false
  end

  def metafy( *options )
    cattr_accessor :metafied_attrs
    self.metafied_attrs = options

    # Sets to determine what classes have been metafied
    @metafied = self.metafied_attrs.count > 0

    meta_joins = []
    class_name = self.name.classify
    table_name = self.table_name
    meta_selects = ["#{table_name}.*"]
    self.metafied_attrs.each do |col|
      meta_joins.push("LEFT JOIN mattrs m_#{col.to_s} ON m_#{col.to_s}.target_id=#{table_name}.id AND m_#{col.to_s}.meta_key='#{col.to_s}' AND m_#{col.to_s}.target_type='#{class_name}'")
      meta_selects.push("m_#{col.to_s}.meta_value AS #{col.to_s}")
    end

    default_scope :select => meta_selects, :joins => meta_joins

    scope :meta_where, lambda { |options|
      conditions = {}
      options.each_pair do |key,val|
        conditions["m_#{key.to_s}".to_sym] = { :meta_value => val }
      end

      where(conditions)
    }
    
    has_many :mattr, :as => :target

    options.each do | meta_attr |
      attr_accessor meta_attr.to_sym
    end

    include Metafy::Base
  end
end