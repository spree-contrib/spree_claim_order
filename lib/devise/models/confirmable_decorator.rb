module Devise
  module Models
    Confirmable.module_eval do

      alias :devise_confirm! :confirm!
      def confirm!
        devise_confirm! && claim_all_unclaimed_orders
      end

      protected

      alias :devise_confirmation_required? :confirmation_required?
      def confirmation_required?
        User.devise_modules.include?(:confirmable) && !unclaimed_orders.empty? && devise_confirmation_required?
      end

    end
  end
end