SpreeClaimOrder
===============

Associates guest orders with real user accounts, if the guest order has the same email address as the user's account. If a user has 'unclaimed' orders, they will be given the opportunity to confirm their email address with a tokenized url. Once email address is confirmed, all unclaimed orders are re-associated to the user's account.

By Default, email confirmation is required before orders can be re-associated. Although not recommended, this requirement may be turned off by setting the the require_email_confirmation preference to false as follows:

    Spree::ClaimOrder::Config.set :require_email_confirmation => false # restart app after changing this preference

Copyright (c) 2010 Zac Williams, released under the New BSD License
