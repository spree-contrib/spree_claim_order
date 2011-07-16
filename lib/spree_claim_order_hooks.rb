class ClaimOrderHooks < Spree::ThemeSupport::HookListener
  Deface::Override.new(:virtual_path => "users/show",
                     :name => "converted_account_summary_213351741",
                     :insert_before => "[data-hook='account_summary'], #account_summary[data-hook]",
                     :partial => "users/resend_confirmation",
                     :disabled => false)
end
