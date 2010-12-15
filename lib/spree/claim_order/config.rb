module Spree
  module ClaimOrder
    # Singleton class to access the shipping configuration object (ClaimOrderConfiguration.first by default) and it's preferences.
    #
    # Usage:
    #   Spree::ClaimOrder::Config[:foo]                  # Returns the foo preference
    #   Spree::ClaimOrder::Config[]                      # Returns a Hash with all the tax preferences
    #   Spree::ClaimOrder::Config.instance               # Returns the configuration object (ClaimOrderConfiguration.first)
    #   Spree::ClaimOrder::Config.set(preferences_hash)  # Set the active shipping preferences as especified in +preference_hash+
    class Config
      include Singleton
      include PreferenceAccess

      class << self
        def instance
          return nil unless ActiveRecord::Base.connection.tables.include?('configurations')
          ClaimOrderConfiguration.find_or_create_by_name("Default claim_order configuration")
        end
      end
    end
  end
end