# encoding: utf-8

#  Copyright (c) 2012-2017, Jungwacht Blauring Schweiz. This file is part of
#  hitobito and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito.

require 'spec_helper'

describe Event::Participation::PeopleController, type: :controller do

  render_views

  let(:event) do
    events(:top_event).tap do |e|
      e.update_column(:required_contact_details, %w(email first_name last_name nickname))
      e.update_column(:optional_contact_details, %w(address town country))
    end
  end

  let(:group) { event.groups.first }

  before { sign_in(people(:top_leader)) }

  context 'GET edit' do
    let(:group) { groups(:top_layer) }
    let(:dom) { Capybara::Node::Simple.new(response.body) }

    it 'does not render not shown contact details' do
      get :edit, group_id: group.id, event_id: event, id: people(:top_leader)

      expect(dom.all('.control-group').count).to be(7)

      # shown attributes
      expect(dom.find('#person_email').present?).to be(true)
      expect(dom.find('#person_first_name').present?).to be(true)
      expect(dom.find('#person_last_name').present?).to be(true)
      expect(dom.find('#person_nickname').present?).to be(true)
      expect(dom.find('#person_address').present?).to be(true)
      expect(dom.find('#person_town').present?).to be(true)
      expect(dom.find('#person_country').present?).to be(true)

      # not shown attributes
      expect(dom.all('#person_company').count).to be(0)
      expect(dom.all('#person_company_name').count).to be(0)
      expect(dom.all('#person_additional_emails').count).to be(0)
      expect(dom.all('#person_phone_numbers').count).to be(0)
      expect(dom.all('#ocial_accounts_fields').count).to be(0)
    end

    it 'highlight required attributes' do
      get :edit, group_id: group.id, event_id: event, id: people(:top_leader)

      expect(dom.all('.required').count).to be(4)
    end
  end

end
