class Meta < ActiveRecord::Base
  def self.meta(target_type, target_id, meta_key)
    Meta.where({ :target_type => target_type, :meta_key => meta_key, :target_id => target_id }).first
  end
  
  def self.meta=(args)
    return false if args.nil? or !args.is_a?(Array) or args.length < 4
    Meta.metas = [ args[0], args[1], { args[2] => args[3] } ]
  end

  def self.metas=(args)
    return if args.nil?
    return unless args.is_a?(Array)
    return unless args[2].is_a?(Hash)

    args[2].each do |k,v|
      unless meta = self.meta(args[0],args[1],k)
        meta = Meta.new
      end

      meta.target_type = args[0]
      meta.target_id   = args[1]
      meta.meta_key    = k
      meta.meta_value  = v
      meta.save
    end
  end

  def self.value(target_type, target_id, meta_key)
    record = self.meta(target_type, target_id, meta_key)
    record.meta_value unless record.nil?
  end
  
  def self.exists?(target_type, target_id, meta_key)
    self.meta(target_type, target_id, meta_key) != false
  end
  
  def self.metas(target_type, target_id)
    Meta.where({ :target_type => target_type, :target_id => target_id })
  end
end