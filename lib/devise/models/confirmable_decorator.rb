module Devise
  module Models
    Confirmable.module_eval do

      def confirm!
        unless_confirmed do
          self.confirmation_token = nil
          self.confirmed_at = Time.now
          save(:validate => false)
        end && claim_all_unclaimed_orders && true
      end

      protected

      def confirmation_required?
        User.devise_modules.include?(:confirmable) && !unclaimed_orders.empty? && !confirmed?
      end

    end
  end
end