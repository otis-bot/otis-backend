require 'rails_helper'

RSpec.describe JWTAuthHelpers, type: :helper do
  describe "#user_info_from_header" do
    it "should return nil when the request does not have an Authorization header" do
      allow(helper).to receive(:headers).and_return({})
      expect(helper.send :user_info_from_header).to eq(nil)
    end

    it "should return nil when the request has an Authorization header that does not start with 'Bearer'" do
      allow(helper).to receive(:headers).and_return({"Authorization" => "Invalid Stuff"})
      expect(helper.send :user_info_from_header).to eq(nil)
    end

    it "should raise a JWT error when the request has an Authorization header with an invalid JWT token" do
      allow(helper).to receive(:headers).and_return({"Authorization" => "Bearer invalid.token.here"})
      expect{helper.send :user_info_from_header}.to raise_error(JWT::DecodeError)
    end

    it "should return a hash with the encoded payload when the request has an Authorization header with a valid JWT token" do
      token = AuthToken.encode({payload: "value", payload_2: "value_2"})
      allow(helper).to receive(:headers).and_return({"Authorization" => "Bearer #{token}"})
      expect(helper.send(:user_info_from_header)[:payload]).to eq("value")
      expect(helper.send(:user_info_from_header)[:payload_2]).to eq("value_2")
    end
  end

  describe "#current_user" do
    it "should return nil when the request does not have an Authorization header" do
      allow(helper).to receive(:headers).and_return({})
      expect(helper.current_user).to eq(nil)
    end

    it "should return nil when the request has an Authorization header that does not start with 'Bearer'" do
      allow(helper).to receive(:headers).and_return({"Authorization" => "Invalid Stuff"})
      expect(helper.current_user).to eq(nil)
    end

    it "should return nil when the request has an Authorization header with an invalid JWT token" do
      allow(helper).to receive(:headers).and_return({"Authorization" => "Bearer invalid.token.here"})
      expect(helper.current_user).to eq(nil)
    end

    it "should return nil when the request has an Authorization header with a JWT token that does not have a user ID" do
      token = AuthToken.encode({stuff: "more stuff"})
      allow(helper).to receive(:headers).and_return({"Authorization" => "Bearer #{token}"})
      expect(helper.current_user).to eq(nil)
    end

    it "should return nil when the request has an Authorization header with a JWT token that does not contain a valid user ID" do
      last_user = User.last
      invalid_id = last_user ? last_user.id + 1 : 1
      token = AuthToken.encode({user_id: invalid_id})
      allow(helper).to receive(:headers).and_return({"Authorization" => "Bearer #{token}"})
      expect(helper.current_user).to eq(nil)
    end

    it "should return the matching user when the request has an Authorization header with a JWT token that contains a valid user ID" do
      user = create :user
      token = AuthToken.encode({user_id: user.id})
      allow(helper).to receive(:headers).and_return({"Authorization" => "Bearer #{token}"})
      expect(helper.current_user).to eq(user)
    end
  end

  describe "#authenticate_user!" do
    before(:each) {helper.define_singleton_method(:error!) {|content, status|}}
     
    describe "without a valid header/JWT token" do
      before (:each) {expect(helper).to receive(:error!).with({message: "Authentication failure"}, 401)}

      it "should call the error! method with the right params when the request does not have an Authorization header" do
        allow(helper).to receive(:headers).and_return({})
        helper.authenticate_user!
      end

      it "should call the error! method with the right params when the Authorization header does not start with 'Bearer'" do
        allow(helper).to receive(:headers).and_return({"Authorization" => "Invalid Stuff"})
        helper.authenticate_user!
      end
  
      it "should call the error! method with the right params when the Authorization header has an invalid JWT token" do
        allow(helper).to receive(:headers).and_return({"Authorization" => "Bearer invalid.token.here"})
        helper.authenticate_user!
      end

      it "should call the error! method with the right params when the JWT token does not have a user ID" do
        token = AuthToken.encode({stuff: "more stuff"})
        allow(helper).to receive(:headers).and_return({"Authorization" => "Bearer #{token}"})
        helper.authenticate_user!
      end

      it "should call the error! method with the right params when the JWT token does not contain a valid user ID" do
        last_user = User.last
        invalid_id = last_user ? last_user.id + 1 : 1 
        token = AuthToken.encode({user_id: invalid_id})
        allow(helper).to receive(:headers).and_return({"Authorization" => "Bearer #{token}"})
        helper.authenticate_user!
      end
    end

    describe "with a valid header and JWT token" do
      it "should not call the error! method when the JWT token contains a valid user ID" do
        user = create :user
        token = AuthToken.encode({user_id: user.id})
        allow(helper).to receive(:headers).and_return({"Authorization" => "Bearer #{token}"})
        expect(helper).to_not receive(:error!)
        helper.authenticate_user!
      end
    end
  end
end
