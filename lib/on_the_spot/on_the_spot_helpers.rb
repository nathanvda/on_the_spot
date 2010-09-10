module OnTheSpot
  module Helpers

    EDIT_TYPE_TEXTAREA='textarea'
    EDIT_TYPE_SELECT='select'

    # Possible options:
    #   ok_text     : the ok-button text
    #   cancel_text : the cancel-button text
    #   tooltip     : the tooltip to show
    #   type        : {'textarea' || 'select' }
    def on_the_spot_edit(object, field, options={})
      #!!! to do: translate options to data-fields
      # Possible fields:
      #  url?
      #  type: textarea or not
      #  button-translations ok-Text, cancel-Text
      #
      options.reverse_merge!(:ok_text     => t('on_the_spot.ok'),
                             :cancel_text => t('on_the_spot.cancel'),
                             :tooltip     => t('on_the_spot.tooltip')
                            )

      update_url = url_for(:action => 'update_attribute_on_the_spot')

      html_options = { :id => "#{object.class.name.underscore}__#{field}__#{object.id}",
                       :class => 'on_the_spot_editing',
                       :'data-url' => update_url}

      html_options[:'data-edittype'] = options[:type] unless options[:type].nil?
      html_options[:'data-ok']       = options[:ok_text] unless options[:ok_text].nil?
      html_options[:'data-cancel']   = options[:cancel_text] unless options[:cancel_text].nil?
      html_options[:'data-tooltip']  = options[:tooltip] unless options[:tooltip].nil?

      content_tag("span", html_options) do
        object.send(field.to_sym).to_s
      end
    end

  end
end