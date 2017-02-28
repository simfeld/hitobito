# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito.

module PeopleHelper

  def format_gender(person)
    person.gender_label
  end

  def dropdown_people_export(details = false, emails = true)
    Dropdown::PeopleExport.new(self, current_user, params, details, emails).to_s
  end

  def format_birthday(person)
    if person.birthday?
      f(person.birthday) << ' ' << t('people.years_old', years: person.years)
    end
  end

  def format_tags(person)
    if person.tags.present?
      person.tags.map(&:name).join(', ')
    else
      t('global.associations.no_entry')
    end
  end

  def sortable_grouped_person_attr(t, attrs, &block)
    list = attrs.map do |attr, sortable|
      if sortable
        t.sort_header(attr.to_sym, Person.human_attribute_name(attr.to_sym))
      else
        Person.human_attribute_name(attr.to_sym)
      end
    end

    header = list[0..-2].collect { |i| content_tag(:span, "#{i} |".html_safe, class: 'nowrap') }
    header << list.last
    t.col(safe_join(header, ' '), &block)
  end

  def send_login_tooltip_text
    entry.password? && t('.send_login_tooltip.reset') ||
      entry.reset_password_sent_at.present? && t('.send_login_tooltip.resend') ||
      t('.send_login_tooltip.new')
  end

  def person_link(person)
    person ? assoc_link(person) : "(#{t('global.nobody')})"
  end

  def event_customized_form_fields(f)
    content = Event::REQUIRED_CONTACT_DETAILS.collect do |attr|
      default_contact_detail_field(attr, f, true)
    end

    content + default_contact_detail_fields(f)
  end

  def default_contact_detail_fields(f)
    Event::DEFAULT_CONTACT_DETAILS.collect do |attr|
      next if event.not_shown_contact_detail?(attr)
      required = event.required_contact_detail?(attr)

      if Event::SPECIAL_CONTACT_DETAILS.include?(attr)
        special_contact_detail_field(attr, f, required)
      else
        default_contact_detail_field(attr, f, required)
      end
    end
  end

  def special_contact_detail_field(attr, f, required)
    return town_contact_detail_field(f, required) if attr == 'town'
    partial_name = "contactable/#{attr.singularize}_fields"
    field_set_tag do
      f.labeled_inline_fields_for(attr, partial_name, nil, required)
    end
  end
  
  def default_contact_detail_field(attr, f, required)
    if required
      f.labeled(attr.to_sym) do
        f.input_field(attr.to_sym) + StandardFormBuilder::REQUIRED_MARK
      end
    else
        f.labeled_input_field(attr.to_sym)
    end
  end

  def town_contact_detail_field(f, required)
    required_mark = required ? StandardFormBuilder::REQUIRED_MARK : ''
    f.labeled(:zip_code, t('contactable.fields.zip_town'), nil, class: 'controls-row') do
      f.string_field(:zip_code, class: 'span2', maxlength: 10) +
      f.input_field(:town, class: 'span4') +
      required_mark
    end
  end
end
