# encoding: utf-8

#  Copyright (c) 2012-2020, Pfadibewegung Schweiz. This file is part of
#  hitobito and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito.

class Event::TypeaheadFilter < Event::Filter

  def initialize(params)
    @type = params[:type]
  end

  def scope
    Event.
      where(type: type).
      order_by_date.
      distinct
  end
end
