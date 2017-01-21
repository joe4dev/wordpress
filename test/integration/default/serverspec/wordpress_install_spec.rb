require 'spec_helper'

describe "wordpress::install" do
  it "is listening on port 80" do
    expect(port(80)).to be_listening
  end

  it "has a running service of mysql-default" do
    expect(service("mysql-default")).to be_running
  end

  it "has a running service of apache2" do
    expect(service("apache2")).to be_running
  end

	describe command('wget http://33.33.33.71 -O - -q') do
	  its(:stdout) { should contain('My WordPress Blog') }
	end
end
