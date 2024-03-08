# frozen_string_literal: true

# Taken from the cucumber-rails project.
# Module containing navigation helpers for mapping page names to paths.
module NavigationHelpers
  PAGE_PATHS = {
    'the home page' => '/',
    'the winning page' => '/win',
    'the losing page' => '/lose',
    'the show page' => '/show'
  }.freeze

  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    PAGE_PATHS[page_name] || raise("Can't find mapping from \"#{page_name}\" to a path.\n" \
                                    "Now, go and add a mapping in #{__FILE__}")
  end
end
