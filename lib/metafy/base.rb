module Metafy
  module Base
    def initialize(attributes = nil)
      unless attributes.nil?
        super(attributes.except(*self.metafied_attrs))
        define_accessors_for_attributes
        attributes.each do |n,v|
          set_metafied_attribute(n,v) if has_metafied_attribute?(n)
        end
      else
        super(nil)
      end
    end

    def has_metafied_attribute?(attribute)
      return self.metafied_attrs.include?(attribute.to_sym)
    end

    def read_metafied_attribute(attribute)
      has_metafied_attribute?(attribute.to_sym) ? Meta.value(self.class.name, self.id, attribute.to_s) : nil
    end

    def write_metafied_attributes
      self.metafied_attrs.each do | meta_attr |
        write_metafied_attribute( meta_attr )
      end
    end

    def write_metafied_attribute( meta_attr )
      meta_attr = meta_attr.to_sym

      old_meta = read_metafied_attribute( meta_attr )
      new_meta = get_metafied_attribute( meta_attr )
      
      if( old_meta != new_meta )
        Meta.meta = [ self.class.name, self.id, meta_attr.to_s, get_metafied_attribute( meta_attr ) ]
      end
    end

    def populate_metafied_attributes
      define_accessors_for_attributes

      attributes = Meta.metas(self.class.name, self.id)
      attributes.each do | meta_attr |
        set_metafied_attribute( meta_attr.meta_key.to_sym, meta_attr.meta_value.to_s )
      end
    end

    def singleton_class
      class << self
        self
      end
    end

    def define_accessor_for_attribute(att)
      singleton_class.send(:attr_accessor, att.to_sym)
    end
    
    def define_accessors_for_attributes
      self.metafied_attrs.each do | meta_attr |
        unless respond_to?(meta_attr.to_s)
          define_accessor_for_attribute(meta_attr)
        end
      end
    end

    def self.included object
      super
      object.after_initialize :populate_metafied_attributes
      object.after_find :populate_metafied_attributes
      object.after_save :write_metafied_attributes
    end

    def set_metafied_attribute(att, value = nil)
      unless respond_to?(att.to_s + '=')
        define_accessor_for_attribute(att)           
      end

      send(att.to_s + '=', value)
    end

    def get_metafied_attribute(att)
      unless respond_to?(att.to_s)
        define_accessor_for_attribute(att)
      end

      send(att.to_s)
    end

    # overrides update_attributes to take meta attributes into account
    def update_attributes(attributes)
      attributes.each do |n,v|
        if has_metafied_attribute?(n.to_sym)
          set_metafied_attribute( n.to_sym, v )
          write_metafied_attribute( n.to_sym )
        end
      end

      attributes.nil? ? super(nil) : super(attributes.except(*self.metafied_attrs))
    end
  end
end

# Adds the metafy_atts method in ActiveRecord::Base, which can be used to define the metafied objects.
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
      meta_joins.push("LEFT JOIN metas m_#{col.to_s} ON m_#{col.to_s}.target_id=#{table_name}.id AND m_#{col.to_s}.meta_key='#{col.to_s}' AND m_#{col.to_s}.target_type='#{class_name}'")
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
    
    has_many :metas, :as => :target

    options.each do | meta_attr |
      attr_accessor meta_attr.to_sym
    end

    include Metafy::Base
  end
end