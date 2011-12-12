# Change History / Release Notes

## Version 0.0.18 (11/12/2011)

* added support for a `:display_method` which will make working with formatted editable content much easier
* added the option to specify a function to verify the access

## Version 0.0.17 (1/11/2011)

* added support for `onblur` action: when focus is lost, allow to autosave.
* make sure that the loadurl can also work if not using a select. This allows the usage of TinyMCE, Markdown or otherwise formatted editable content.

## Version 0.0.16 (12/10/2011)

* added support for checkboxes (thanks to Peter Savichev)

## Version 0.0.14 (13/9/2011)

* Fixed bugs #17 and #20
* Improved rails 3.1 compatibility

## Version 0.0.13 (24/7/2011)

* Made on_the_spot rails 3.1 compatible

## Version 0.0.12 (02/07/2011)

* Added the option to execute a callback after editing

You will have to upgrade the javascript files as well after update:

    rails g on_the_spot:install

This will copy the new `on_the_spot.js` files to your `public/javascripts` folder.

## Version 0.0.11 (29/05/2011)

* refactored the JS to allow dynamically adding on_the_spot fields (more cleanly).

There is no real need to update, unless you need or want to use this functionality.

You will have to upgrade the javascript files as well after update:

    rails g on_the_spot:install

This will copy the new `on_the_spot.js` files to your `public/javascripts` folder.


