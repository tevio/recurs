Feature:
  In order to easily generate recurrence interfaces with their complex rest logic
  As a user of Rails3
  I would like to use recurs generators

  Scenario: The recurs generators create a recurs scaffold
    for each model that I generate with a recurs generator
    #Given I run "rake build"
    #And I run "gem install pkg/recurs-0.0.4.2.gem"
    Given I run "rails new test_app"
    And I cd to "test_app"
    And a file named "Gemfile" with:
    """
    source "http://rubygems.org"
    gem 'rails', '3.0.0'
    gem 'sqlite3-ruby', :require => 'sqlite3'
    gem 'recurs' #, :path => '../../../'
    """
    #And I run "bundle install"
    And I run "rails generate recurs_widget Event"
    #Then the output should contain:
    #  """
    #    create  app/models/event.rb
    #
    #  """
    And the following files should exist:
      | app/models/event.rb |
      | app/views/events/index.html.haml |
      | app/views/events/new.html.haml |
      | app/views/events/edit.html.haml |
      | app/views/events/_form.html.haml |
      | app/views/events/schemes/_monthly.html.haml |
      | app/views/events/schemes/_set_points.html.haml |
      | app/views/events/schemes/_standard.html.haml |
      | app/views/events/schemes/_weekly.html.haml |
    And the file "app/models/event.rb" should contain exactly:
  """
  class Event < ActiveRecord::Base
    acts_as_recurring
  end
  """
    And the file "app/views/events/_form.html.haml" should contain exactly:
"""
= form_for @event do |f|
  -if @event.errors.any?
    #errorExplanation
      %h2= "#{pluralize(@event.errors.count, "error")} prohibited this recurrence from being saved:"
      %ul
        - @event.errors.full_messages.each do |msg|
          %li= msg

  .field
  .field
    = f.label :repeats
    = f.select :repeats, Event.schemes

  - if flash[:interval]
    .field
      = f.label :repeats_every
      = f.select :interval, 1..52, :class => :left
      = @recurs_template[1]

    = render :partial => "recurrences/schemes/#{@recurs_template[0]}"

    .field
      = f.label :starts_at
      = f.datetime_select :starts_at
    .field
      = f.label :ends_at
      = f.datetime_select :ends_at
    .field
      = f.label :never_ends
      = f.check_box :never_ends
    .field
      = f.label :summary
      = f.text_field :summary
  .actions
    = f.submit 'Save'
"""
    #And the following files should not exist:
    #And I run "rake db:migrate"