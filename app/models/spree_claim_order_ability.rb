class SpreeClaimOrderAbility
  include CanCan::Ability

  def initialize(user)
    #############################
    can :assign_to_rightful_owner, Order do |order|
      user.confirmed? && (user.email.downcase == order.email.downcase)
    end
  end
end

Ability.register_ability(SpreeClaimOrderAbility)