class ClaimOrderHooks < Spree::ThemeSupport::HookListener
  insert_before :account_summary, 'users/resend_confirmation'
  insert_after :account_my_orders, 'users/unclaimed_orders'
end