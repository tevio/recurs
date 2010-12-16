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
      | app/controllers/events_controller.rb |
    And the file "app/models/event.rb" should contain exactly:
  """
  class Event < ActiveRecord::Base
    acts_as_recurring
  end
  """


    And the file "app/views/events/new.html.haml" should contain exactly:
  """
  %h1 New event

  = render 'form'

  = link_to 'Back', events_path
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
    And the file "app/views/events/edit.html.haml" should contain exactly:
  """
  %h1 Edit event

  = render 'form'

  = link_to 'Show', @event
  \|
  = link_to 'Back', events_path
  """
    And the file "app/views/events/index.html.haml" should contain exactly:
  """
  %h1 Listing events

  %table
    %tr
      %th Starts on
      %th Ends on date
      %th Recurrence
      %th Summary
      %th
      %th
      %th

    - @events.each do |event|
      %tr
        %td= event.starts_at
        %td= event.ends_at
        %td= event.rrule
        %td= event.summary
        %td= link_to 'Show', event
        %td= link_to 'Edit', edit_event_path(event)
        %td= link_to 'Destroy', event, :confirm => 'Are you sure?', :method => :delete

  %br

  = link_to 'New event', new_event_path
  """
    And the file "app/controllers/events_controller.rb" should contain exactly:
  """
  class EventsController < ApplicationController
    # GET /events
    # GET /events.xml
    def index
      @events = Event.all

      respond_to do |format|
        format.html # index.html.erb
        format.xml  { render :xml => @events }
      end
    end

    # GET /events/1
    # GET /events/1.xml
    def show
      @event = Event.find(params[:id])

      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @event }
      end
    end

    # GET /events/new
    # GET /events/new.xml
    def new
      @event = Event.new
      if flash[:repeats]
        flash[:scheme] = flash[:repeats]
        @event_template = Event.scheme(flash[:repeats]).call
      end

      respond_to do |format|
        format.html # new.html.erb
        format.xml  { render :xml => @event }
      end
    end

    # GET /events/1/edit
    def edit
      @event = Event.find(params[:id])
    end

    # POST /events
    # POST /events.xml
    def create
      unless flash[:repeats]
        flash[:repeats] = params[:event][:repeats].to_i
        redirect_to new_event_path
      else
        #@event = Event.new(params[:event])
        Event.scheme(flash[:scheme]).call(:set => params[:event])
      end
    end

    # PUT /events/1
    # PUT /events/1.xml
    def update
      @event = Event.find(params[:id])

      respond_to do |format|
        if @event.update_attributes(params[:event])
          format.html { redirect_to(@event, :notice => 'Event was successfully updated.') }
          format.xml  { head :ok }
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
        end
      end
    end

    # DELETE /events/1
    # DELETE /events/1.xml
    def destroy
      @event = Event.find(params[:id])
      @event.destroy

      respond_to do |format|
        format.html { redirect_to(events_url) }
        format.xml  { head :ok }
      end
    end
  end
  """
    #And the following files should not exist:
    #And I run "rake db:migrate"