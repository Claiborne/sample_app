# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe User do

  before(:each) do
    @attr = {
      :name => 'Example User',
      :email => 'user@example.com',
      :password => 'foobar',
      :password_confirmation => 'foobar'
    }
  end

  it 'should create a new instance given valid attributes' do
    User.create!(@attr)
  end

  it 'should require a non-blank name' do
    no_name_user = User.new @attr.merge(:name => "")
    no_name_user.should_not be_valid
    no_name_user = User.new @attr.merge(:name => "  ")
    no_name_user.should_not be_valid
  end

  it 'should limit name length to 50' do
    long_name = 'a' * 51
    long_name_user = User.new @attr.merge(:name => long_name)
    long_name_user.should_not be_valid
  end

  it 'should require a non-blank email' do
    no_email_user = User.new @attr.merge(:email => "")
    no_email_user.should_not be_valid
    no_email_user = User.new @attr.merge(:email => "   ")
    no_email_user.should_not be_valid
  end

  it 'should accept valid email addresses' do
    addresses = %w(user@foo.com THE_USER@foo.bar.org first.last@foo.jp)
    addresses.each do |address|
      valid_email_user = User.new @attr.merge(:email => address)
      valid_email_user.should be_valid
    end
  end

  it 'should reject invalid email addressed' do
    addresses = %w(user@foo,com user_at_foo.org example.user@foo.)
    addresses.each do |address|
      invalid_email_user = User.new @attr.merge(:email => address)
      invalid_email_user.should_not be_valid
    end
  end
=begin
  it 'should reject a duplicate email address' do
    User.create! @attr
    duplicate_email_user = User.create! @attr
    duplicate_email_user.should_not be_valid
  end

  it 'should reject email identical up to case' do
    upcased_email = @attr[:email].upcase
    User.create! @attr.merge(:email => upcased_email)
    duplicate_email_user = User.new @attr
    duplicate_email_user.should_not be_valid
  end
=end

  describe 'password validations' do

    it 'should require a password' do
      (User.new @attr.merge(:password => '', :password_confirmation => '')).should_not be_valid
    end

  end

  describe 'authenticate method' do

    it 'should return nil on email/password mismatch' do
      wrong_password_user = User.authenticate @attr[:email], 'wrong'
      wrong_password_user.should be_nil
    end

    it 'should return nil for an email address wit no user' do
      nonexistent_user = User.authenticate 'bar@foo.com', @attr[:password]
      nonexistent_user.should be_nil
    end

    it 'should return the user on email/password match' do
      matching_user = User.authenticate @attr[:email], @attr[:password]
      matching_user.should == @user
    end

  end

end
