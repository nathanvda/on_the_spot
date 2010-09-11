# on_the_spot

On-the-spot is a Rails3 compliant unobtrusive javascript in-place-editing plugin, using jEditable.
This is still in progress, but should already be usable for simple text-fields and text-areas.

## Installation

Inside your `Gemfile` add the following:

    gem "on_the_spot"

Run the installation task:

    rails g on_the_spot:install

Inside your `routes.rb` you either provide the catch-all

    match ':controller(/:action(/:id(.:format)))'

or you type something like

    resources :posts do
      collection do
        get :update_attribute_on_the_spot
      end
    end

While this last is the best solution, you need to do this for each controller that uses the on-the-spot editing.
For the moment i do not know of any better solution, but i am always open for suggestions!

Inside your `application.html.haml` you will need to add below the default javascripts:

    = javascript_include_tag :on_the_spot

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

The `on_the_spot_edit` also accepts options:

* `type`    : `textarea` or `select` (none means default edit, select is currently not yet supported)
* `ok_text` : the text for the ok-button
* `cancel_text` : the text for the cancel-button
* `tooltip` : the tooltip-text

For the texts: if a text is not specified, the default is taken from the `on_the_spot.en.yml` (or your current language).

## Example project

Ther is a example rails3-project called [on_the_spot_tester](http://github.com/nathanvda/on_the_spot_tester)

## To do

- make sure user can choose to use a select instead of just text or textarea
- add tests!

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
