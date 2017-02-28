# encoding: utf-8

#  Copyright (c) 2012-2017, Jungwacht Blauring Schweiz. This file is part of
#  hitobito and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito.

class Event::Participation::PeopleController < PeopleController

  helper_method :event, :group

  alias_method :group, :parent

  private
  
  def return_path
    new_group_event_participation_path(group, event)
  end
  
  def event
    @event ||= Event.find(params[:event_id])
  end

  def model_scope
    Person
  end

  def save_entry
    return false unless entry.valid_for_event?(event)
    entry.save
  end

end
