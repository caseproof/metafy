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
      has_metafied_attribute?(attribute.to_sym) ? Mattr.value(self.class.name, self.id, attribute.to_s) : nil
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
        Mattr.meta = [ self.class.name, self.id, meta_attr.to_s, get_metafied_attribute( meta_attr ) ]
      end
    end

    def populate_metafied_attributes
      define_accessors_for_attributes

      attributes = Mattr.metas(self.class.name, self.id)
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