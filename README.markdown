# on_the_spot

On-the-spot is a Rails3 compliant unobtrusive javascript in-place-editing plugin, using jEditable.
(currently a work in progress, extracted it from a rails3 application)

## Installation

Inside your `Gemfile` add the following:

    gem "on_the_spot"

Run the installation task:

    rails g on_the_spot:install

Inside your `routes.rb` you provide the catch-all

      match ':controller(/:action(/:id(.:format)))'

This is not ideal: i am looking for a better solution.

But that is all you need to do to start using it!


## Usage
Inside your controller you write:


    class YourController < ApplicationController

      can_edit_on_the_spot

      ... leave the rest of your controller alone ...

    end

And inside your view you will have to specify the fields you want to be "editable" :

    Username: <%= on_the_spot_edit @user, :name %>


It should be as simple as that :)

## To do

- make sure you can overrule ok/cancel texts
- make sure user can choose to use a textarea instead of just text
- find a clean solution for the routes

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
