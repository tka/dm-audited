require 'dm-core'
require 'dm-timestamps'
require 'dm-serializer'

module DataMapper
  module Audited
    def self.included(base)
      base.extend(ClassMethods)
    end

    module InstanceMethods

      def create_audit(action)
        if defined?(CurrentRequest)
          request = CurrentRequest::Holder.current_request  
        else
          raise "install http://github.com/mauricio/current_request first"
        end

        if defined?(::Devise) && request
          users={}
          ::Devise.mappings.keys.each do | key |
            warden=request.env['warden']
            users[key]= warden.user(key).id if warden.user(key)
          end
        else
          user = nil
        end
        
        if @audited_attributes
          changed_attributes = {}
          @audited_attributes.each do |key, val|
            if properties[key.name] && attribute_get(key.name) != val 
              changed_attributes[key.name] = [val, attribute_get(key.name)] 
            elsif !properties[key.name] && self.send(key.name) != val
              x=self.send(key.name)
              if !x.class.name.blank?
                changed_attributes[key.name] = [val, x] 
              end
            end
              
          end

          audit_attributes = {
            :auditable_type => self.class.to_s,
            :auditable_id   => self.id,
            :users       => users,
            :action         => action,
            :changes_yaml        => changed_attributes
          }
          if request
            params = request.params
            if defined?(::Application) && defined?(Merb::Controller)
              params = Application._filter_params(params)
            end

            audit_attributes.merge!(
              :request_uri    => request.fullpath,
              :request_method => request.request_method,
              :request_params => params
            )
          end

          unless self.frozen?
            remove_instance_variable("@audited_attributes")
            remove_instance_variable("@audited_new_record") if instance_variable_defined?("@audited_new_record")
          end

          x=Audit.create(audit_attributes) unless changed_attributes.empty? && action != 'destroy'
        end
      end

      def audits
        Audit.all(:auditable_type => self.class.to_s, :auditable_id => self.id.to_s, :order => [:created_at, :id])
      end

    end

    module ClassMethods
      def is_audited

        include DataMapper::Audited::InstanceMethods

        before :save do
          @audited_attributes = original_attributes.clone
          @audited_new_record = new?
        end

        before :destroy do
          @audited_attributes = original_attributes.clone
        end

        after :save do
          create_audit(@audited_new_record ? 'create' : 'update')
        end

        after :destroy do
          create_audit('destroy')
        end

      end
    end

    class Audit
      include DataMapper::Resource

      property :id,             Serial
      property :auditable_type, String
      property :auditable_id,   Integer
      property :users,           Object
      property :request_uri,    String, :length => 255
      property :request_method, String
      property :request_params, Object
      property :action,         String
      property :changes_yaml,   Text
      property :created_at,     DateTime

      def auditable
        ::Object.full_const_get(auditable_type).get(auditable_id)
      end
      
      def users
        if self['users'] 
          if defined?(::Devise)
            r={}
            self['users'].each do | role, id|
            r[role.to_sym]= Kernel.const_get(role.to_s.capitalize).find id
            end
            r

          end
        else
          nil
        end
      end

      def changes_yaml=(property)
        attribute_set(:changes_yaml, property.to_yaml)
      end

      def changes
        @changes_hash ||= YAML.load(attribute_get(:changes_yaml))
      end

    end
    
    Model.append_inclusions self
  end

end
