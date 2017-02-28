# encoding: utf-8

#  Copyright (c) 2012-2017, Jungwacht Blauring Schweiz. This file is part of
#  hitobito and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito.

require 'spec_helper'

describe Event::Participation::PeopleController do

  context 'PUT #update' do
    
    let(:group) { groups(:top_layer) }
    let(:event) { events(:top_event) }
    let(:person) { people(:top_leader) }

    before do 
      sign_in(people(:top_leader)) 
      event.update_attributes(required_contact_details: ['first_name', 'last_name', 'email', 'nickname'])
    end

    it 'updates if valid for event and redirects' do
      put :update, group_id: group.id,
                   event_id: event.id,
                   id: person.id,
                   person: { first_name: 'testperson',
                             last_name: 'foo',
                             email: 'foo@example.com',
                             nickname: 'foobi' }

      is_expected.to redirect_to new_group_event_participation_path(group, event)

      person.reload

      expect(person.first_name).to eq('testperson')
      expect(person.last_name).to eq('foo')
      expect(person.email).to eq('foo@example.com')
      expect(person.nickname).to eq('foobi')
    end

    it "does not update if the person isn't valid for event" do
      put :update, group_id: group.id,
                   event_id: event.id,
                   id: person.id,
                   person: { first_name: 'testperson' }
      
      is_expected.to_not redirect_to new_group_event_participation_path(group, event)

      person.reload

      expect(person.first_name).to eq(person.first_name)
    end

    it 'does not update if person is valid for event but not for person validation' do
      put :update, group_id: group.id,
                   event_id: event.id,
                   id: person.id,
                   person: { first_name: 'testperson',
                             last_name: 'foo',
                             email: 'no-email',
                             nickname: 'foobi' }

      is_expected.to_not redirect_to new_group_event_participation_path(group, event)

      person.reload

      expect(person.first_name).to eq(person.first_name)
    end

    it "does not update if assoiciated attribute is required, created but not valid" do
      event.update_attributes(required_contact_details: ['first_name', 'additional_emails'])
      
      expect do
        put :update, group_id: group.id,
                     event_id: event.id,
                     id: person.id,
                     person: { first_name: 'testperson',
                               additional_emails_attributes: [ {email: ''} ] }
      end.not_to change { AdditionalEmail.count }

      is_expected.to_not redirect_to new_group_event_participation_path(group, event)
      
      person.reload

      expect(person.first_name).to eq(person.first_name)
    end
  end
end
