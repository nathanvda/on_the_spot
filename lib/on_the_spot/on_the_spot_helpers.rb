module OnTheSpot
  module Helpers

    EDIT_TYPE_TEXTAREA='textarea'
    EDIT_TYPE_SELECT='select'

    class OnTheSpotMissingParameters < StandardError; end

    # Possible options:
    #   ok_text      : the ok-button text
    #   cancel_text  : the cancel-button text
    #   tooltip      : the tooltip to show
    #   type         : {'textarea' || 'select' }
    #   rows         : nr of rows for textarea
    #   columns      : nr of columns for textarea
    #   loadurl      : (for select) an url that will return the json for the select
    #   display_text : either overrule the normal display-value, or needed when using loadurl
    #   data         : (for select) an array of options in the form [id, value]
    #   url          : (optional) URL to post to if you don't want to use the standard routes
    #   selected     : (optional) boolean, text selected on edit
    #   callback     : (optional) a javascript function that is called after form has been submitted
    def on_the_spot_edit(object, field, options={})
      options.reverse_merge!(:ok_text     => t('on_the_spot.ok'),
                             :cancel_text => t('on_the_spot.cancel'),
                             :tooltip     => t('on_the_spot.tooltip'),
                             :rows        => 5,
                             :columns     => 40,
                             :url         => {:action => 'update_attribute_on_the_spot'}
                            )

      options[:url].merge!(:raw => true) if options[:raw]
      update_url = url_for(options[:url])

      field_value =  object.send(field.to_sym).to_s
      field_value = field_value.html_safe if options[:raw]

      html_options = { :id => "#{object.class.name.underscore}__#{field}__#{object.id}",
                       :class => 'on_the_spot_editing',
                       :'data-url' => update_url}

      editable_type = options[:type].nil? ? nil : options[:type].to_sym
      html_options[:'data-edittype']    = editable_type.to_s unless editable_type.nil?
      if editable_type == :select && options[:loadurl].nil?
        # we should find a hash
        select_data = options[:data]
        raise OnTheSpotMissingParameters.new("Using type select needs either data or loadurl to function!") if select_data.nil?
        html_options[:'data-select']  = convert_array_to_json(select_data, field_value)
      elsif editable_type == :textarea
        html_options[:'data-rows']         = options[:rows]
        html_options[:'data-columns']      = options[:columns]
      end
      html_options[:'data-ok']             = options[:ok_text]
      html_options[:'data-cancel']         = options[:cancel_text]
      html_options[:'data-tooltip']        = options[:tooltip]
      html_options[:'data-auth']           = form_authenticity_token if defined? form_authenticity_token
      html_options[:'data-selected']       = options[:selected]
      html_options[:'data-callback']       = options[:callback]
      html_options[:'data-onblur']         = options[:onblur] if options[:onblur] && ['cancel','submit', 'ignore'].include?(options[:onblur])
      html_options[:'data-loadurl']        = options[:loadurl] unless options[:loadurl].nil?
      html_options[:'data-display-method'] = options[:display_method] unless options[:display_method].nil?
      if html_options[:'data-display-method'].present? && html_options[:'data-loadurl'].nil?
        html_options[:'data-loadurl'] = url_for(:action => 'get_attribute_on_the_spot')
      end
        
      content_tag("span", html_options) do
        if options[:display_text]
          options[:display_text]
        elsif options[:display_method]
          object.send(options[:display_method].to_sym).to_s
        elsif editable_type == :select && options[:loadurl].nil?
          lookup_display_value(select_data, field_value)
        else
          field_value
        end
      end
    end

    def lookup_display_value(id_value_array, id_str)
      found_pair = id_value_array.select{ |idv| idv[0].to_s == id_str.to_s }
      found_pair.size == 0 ? '' : found_pair[0][1]
    end

    def convert_array_to_json(id_value_array, selected_id)
      conv_arr = id_value_array.map{|idv| "'#{idv[0]}':'#{escape_javascript(idv[1])}'" }
      result = "{ #{conv_arr.join(', ')}"
      result += ", 'selected':'#{ selected_id.to_s}'" unless selected_id.nil?
      result += "}"
      result
    end

  end
end
