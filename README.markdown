# on_the_spot

[![Build Status](http://travis-ci.org/nathanvda/on_the_spot.png)](http://travis-ci.org/nathanvda/on_the_spot)

On-the-spot is a Rails3+ compliant unobtrusive javascript in-place-editing plugin, using jEditable, and depends on jQuery.

## Features

* built on proven jQuery plugin `jEditable`
* works on index-pages, nested objects, ...
* can generate simple edit-boxes, textareas, dropdown lists, checkboxes
* will check your server-side validations and show the error
* you can check the access-rights before doing any update (to check against tampering)
* you can use custom display methods, e.g when using markdown
* there is a [sample project](https://github.com/nathanvda/on_the_spot_tester) to demonstrate usage (old)


## Installation

Inside your `Gemfile` add the following:

    gem "on_the_spot"

Run the installation task:

    rails g on_the_spot:install

This will copy the default translation files, and for rails 3.0 it will also copy the needed assets (javascript files).

### Rails 6 

Add the componanion package

    yarn add @nathanvda/on_the_spot 
    
and then in your `app/javascripts/packs/application.js` you should add

    require("jquery")
    require("jquery-jeditable")
    require("@nathanvda/on_the_spot")

 
    

### Rails 3.1+/4/5

Add the following to application.js so it compiles to the asset_pipeline

    //= require on_the_spot

Or, inside your `application.html.haml` you could still include the needed javascripts, using

    = javascript_include_tag :on_the_spot

To use the default styling, add the following to `application.css` so it compiles to the asset_pipeline

	*= require on_the_spot

Or, inside your `application.html.haml` you could still include the needed css, using

	= stylesheet_link_tag :on_the_spot


### Rails 3.x

> Breaking changes: since rails 5 render :text is deprecated and removed, this means that starting from 1.1.0
> this gem is no longer compatible with rails 3, but is compatible with rails 4 and 5.
> So if you are still using rails 3.x you need the fixate the version to `1.0.6`


     gem 'on_the_spot', '1.0.6'



### Rails 3.0.x

Inside your `application.html.haml` you will need to add below the default javascripts:

    = javascript_include_tag :on_the_spot

or using erb, you write

    <%= javascript_include_tag :on_the_spot %>

To use the default styling, inside your `application.html.haml` you will need to add below the default CSS:

    = stylesheet_link_tag :on_the_spot

or using erb, you write

    <%= stylesheet_link_tag :on_the_spot %>


### Routes (for all Rails versions)

Inside your `routes.rb` you need to provide the following route :

    resources :posts do
      collection do
        put :update_attribute_on_the_spot
        get :get_attribute_on_the_spot
      end
    end

You need to do this for each controller that uses the on-the-spot editing.

You only need to specify the route for `get_attribute_on_the_spot` if you make use of the `:display_method` option,
and do not want to supply your own load-function.

That is all you need to do to start using it!


## Usage
Inside your controller you write:


    class YourController < ApplicationController

      can_edit_on_the_spot

      ... leave the rest of your controller alone ...

    end

And inside your view you will have to specify the fields you want to be "editable" :

    Username: <%= on_the_spot_edit @user, :name %>


It should be as simple as that :)

## Detailed options

The `can_edit_on_the_spot` accepts options:

* `:is_allowed`: method-name to call to check if the update is allowed to be performed
* `:on_success`: method-name that is called when the update was succesfully performed, this could be used for audit-logging a.o.

The `on_the_spot_edit` also accepts options:

* `:type`    : `:textarea`, `:select` or `:checkbox` (none means default edit)
* `:ok_text` : the text for the ok-button
* `:cancel_text` : the text for the cancel-button
* `:display_text`: if you want to overrule the displayed text, especially useful when using your own `:url` or `:loadurl`
* `:tooltip` : the tooltip-text
* `:form_css`: the css class for the form
* `:input_css`: the css class for the input itself
* `:rows`: for textarea, the number of rows, defaults to 5
* `:columns`: for textarea, the number of columns, defaults to 40
* `:data`: for select, the lookup-data, should be in an array of id-value pairs. E.g. `[[1, 'ok'], [2, 'not ok'], [3, 'not decided']]`.
* `:loadurl`: for select, an url that will return the data in JSON format (use instead of `:data`)
* `:url`: URL to post to if you don't want to use the standard routes
* `:selected`: Text selected by default on edit (boolean, default is false)
* `:callback`: The name of a javascript function that is called after form has been submitted
* `:display_method`: the name of a method that is used to get the value to display of a field. When you use this, we will automatically
   attempt to look up the raw value of the field to edit.  This differs from the `:display_text` option, as this will also be called after update.
   This supersedes the `:display_text` option.
* `:raw`: if set to true, evaluate the field value as raw HTML.
* `:onblur`: accepts `cancel`, `submit` or `ignore` changes the behavior of the onblur handler accordingly


For the texts and css classes: if a text is not specified, the default is taken from the `on_the_spot.en.yml` (or your current language).

E.g. in the translations file `on_the_spot.en.yml` you could do the following to get the inline editor look good when using bootstrap: 

```
en:
  on_the_spot:
    ok: <button class="btn btn-primary btn-sm">Ok</button>
    cancel: <button class="btn btn-sm">Cancel</button>
    tooltip: Click to edit ...
    access_not_allowed: Access is not allowed
    form_css: 'form form-inline'
    input_css: 'form-control'
```


## Styling

Each element that is editable will have the `on_the_spot_editing` class.

When an element is moused over, it will get the `on_the_spot_over` class.

You can use these classes to style the elements.

## Example Usages

### Edit field

    <%= on_the_spot_edit @user, :name %>

### Textarea

    <%= on_the_spot_edit @user, :description, :type => :textarea, :rows => 10, :columns => 55 %>

### Select-box

    <%= on_the_spot_edit @user, :rating, :type => :select, :data => [[1, 'good'], [2, 'mediocre'], [3, 'bad']] %>

### Callback

    Somewhere in a .js file:
    function testCallback(object, value, settings) {
      console.log(object);
      console.log(value);
      console.log(settings);
    }

    <%= on_the_spot_edit @user, :name, :callback => 'testCallback' %>


## Using together with `cancan`

When using `on_the_spot` together with `cancan`, you will have to explicitly exclude the on_the_spot method,
like so:

    load_and_authorize_resource :except => [:update_attribute_on_the_spot, :get_attribute_on_the_spot]

The `load_and_authorize_resource` will try to find the object, based on the id in the parameters, but `on_the_spot` uses a different
encoding to store the object, field and id in one attribute. So if you exclude that, there will not be a problem.


## Using together with an authorization system (e.g. Cancan)

If you want to test access-rights, you can do so by specifying a method which will be called

In your controller write:

    can_edit_on_the_spot :check_access

    def check_access(object, field)
      # verify that the current user has access to edit/see the field of given object
    end


Note, there are two identical ways to add this: either you use the _old format_ : `can_edit_on_the_spot :method_name` or
you could use the new format: `can_edit_on_the_spot is_allowed: :check_access`. Both are identical


## Performing an action upon succesful update

If you want to perform some action upon succesfully updating a field,
you can specify a method to do just that.


In your controller write:

    can_edit_on_the_spot on_success: :log_changes

    protected

    def log_changes(updated_object, field, value)
      Rails.logger.debug("We updated #{updated_object.name} and set #{field} to #{value}")
    end


## Example project

There is an example rails3-project called [on_the_spot_tester](http://github.com/nathanvda/on_the_spot_tester)

## Prerequisites

As jEditable depends on jQuery, your rails3 project needs to use jQuery.
It will not work if you use Prototype instead, in your rails3 project.
I have written an article [here](http://www.dixis.com/?p=307) how to start a fresh rails3 project, using jQuery.
In short, you add the following to your `Gemfile`:

    gem "jquery-rails"

and, after a `bundle install`, you run

    rails g jquery:install

That will download and install all the necessary files for you.

## Note on Patches/Pull Requests

* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

## Copyright

Copyright (c) 2010 nathanvda. See LICENSE for details.
