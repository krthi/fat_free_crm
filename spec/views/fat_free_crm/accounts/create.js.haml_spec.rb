# frozen_string_literal: true

# Copyright (c) 2008-2013 Michael Dvorkin and contributors.
#
# Fat Free CRM is freely distributable under the terms of MIT license.
# See MIT-LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
require 'spec_helper'

module FatFreeCrm
  describe "/fat_free_crm/accounts/create" do

    before do
      login
    end

    # Note: [Create Account] is only called from Accounts index. Unlike other
    # core object Account partial is not embedded.
    describe "create success" do
      let!(:account) { create(:account) }
      before do
        assign(:account, account)
        assign(:accounts, [build_stubbed(:account, id: 10)].paginate)
        assign(:account_category_total, Hash.new(1))
        render
      end

      it "should hide [Create Account] form and insert account partial" do
        expect(rendered).to include("$('#accounts').prepend('<div class=\\'form-group one-half reporting-account\\'>\\n<li class=\\'highlight account\\' id=\\'account_#{account.id}\\'")
        expect(rendered).to include(%/$('#account_#{account.id}').effect("highlight"/)
      end

      it "should update pagination" do
        expect(rendered).to include("#paginate")
      end

      it "should refresh accounts sidebar" do
        expect(rendered).to include("#sidebar")
        expect(rendered).to have_text("Account Categories")
        expect(rendered).to have_text("Recent Items")
      end
    end

    describe "create failure" do
      it "should re-render [create] template in :create_account div" do
        assign(:account, build(:account, name: nil)) # make it invalid
        assign(:accounts, [build_stubbed(:account, id: 10)].paginate)
        assign(:users, [current_user])
        render

        expect(rendered).to include("#create_account")
        expect(rendered).to include(%/$('#create_account').effect("shake"/)
      end
    end
  end
end
