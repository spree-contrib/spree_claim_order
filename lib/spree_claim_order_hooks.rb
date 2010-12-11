class ClaimOrderHooks < Spree::ThemeSupport::HookListener
  insert_after :account_my_orders, 'users/unclaimed_orders'
end