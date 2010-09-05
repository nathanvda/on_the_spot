module OnTheSpot
  module Helpers

    def on_the_spot_edit(object, field, options={})
      #!!! to do: translate options to data-fields
      # Possible fields:
      #  url?
      #  type: textarea or not
      #  button-translations ok-Text, cancel-Text
      #
      update_url = url_for(:action => 'update_attribute_on_the_spot')

      content_tag("span", :id => "#{object.class.name.underscore}__#{field}__#{object.id}",
                  :class => 'on_the_spot_editing',
                  :'data-url' => update_url) do
        object.send(field.to_sym).to_s
      end
    end

  end
end