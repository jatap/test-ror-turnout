require 'spec_helper'
require 'open3'

describe 'Turnout' do
  context 'a maintenance mode with allowed ips' do
    let(:ips) { '5.8.6.7' }

    before :each do
      %x( bundle exec rake maintenance:start allowed_ips="#{ips}" )
    end

    it 'keeps request free' do
      get root_path, {}, { 'REMOTE_ADDR' => ips }
      expect(response.status).to eql 200
      expect(response.body).to match('home')
    end
  end

  context 'a maintenance mode with full options' do
    let(:ips) { '5.6.7.8' }

    before :each do
      %x( bundle exec rake maintenance:start reason="Someone told me I should type <code>sudo rm -rf /</code>" allowed_paths="^/about" allowed_ips="5.6.7.8" )
    end

    it 'keeps requests free' do
      get root_path, {}, { 'REMOTE_ADDR' => ips }
      expect(response.status).to eql 200
      expect(response.body).to match('home')
    end
  end
end

