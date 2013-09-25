require 'spec_helper'

# @todo Refactoring and use rack middleware
module TurnoutFeatureSteps
  def disable
    %x( bundle exec rake maintenance:end )
  end

  def enable
   %x( bundle exec rake maintenance:start )
  end

  def enable_with_reason(reason)
   %x( bundle exec rake maintenance:start reason="#{reason.to_s}")
  end

  def enable_with_paths(paths)
   %x( bundle exec rake maintenance:start allowed_paths="#{paths}" )
  end

  def go_root
    visit root_path
  end

  def go_root_with_remote(remote_addr)
    visit root_path
  end

  def go_about
    visit static_pages_about_path
  end

  def normal_browsing
    disable
    go_root
    expect(page).to have_text('home')
  end

  def activated_with_defaults
    enable
    go_root
    expect(page).to have_text('Maintenance')
  end

  def activated_with_reason(reason)
    enable_with_reason reason
    go_root
    expect(page).to have_text(reason)
  end

  def activated_with_allowed_paths(paths)
    enable_with_paths paths
    go_about
    expect(page).to have_text('About')
  end

  def activated_with_allowed_ips(ips)
    enable_with_ips ips
    go_root_with_remote(ips)
    expect(page).to have_text('home')
  end
end

feature 'Turnout' do
  include TurnoutFeatureSteps

  scenario 'a desactivated web site runs without problems' do
    normal_browsing
  end

  scenario 'a default maintenance mode show default message' do
    activated_with_defaults
  end

  scenario 'a maintenance mode with some reason, shows reason as a message' do
    activated_with_reason('Kaos is comming, we are getting ready.')
  end

  scenario 'a maintenance mode with allowed path, keep request free' do
    activated_with_allowed_paths(static_pages_about_path)
  end
end
