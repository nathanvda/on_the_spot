module OnTheSpot
  module Helpers

    def on_the_spot_edit(object, field, options={})
      #!!! to do: translate options to data-fields
      # Possible fields:
      #  url?
      #  type: textarea or not
      #  button-translations ok-Text, cancel-Text
      #
      content_tag("span", :id => "#{object.class.name.underscore}__#{field}__#{object.id}", :class => in_place_class.to_s) do
        object.send(field.to_sym).to_s
      end
    end

  end
end