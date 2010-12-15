class ClaimOrderHooks < Spree::ThemeSupport::HookListener
  insert_before :account_summary, 'users/resend_confirmation'
end