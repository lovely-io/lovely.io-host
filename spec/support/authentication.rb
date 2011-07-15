#
# Some basic authentication mocks for the controller specs
#
module AuthenticationMocks

  def anonymous!
    controller.stub!(:current_user).and_return(nil)
  end

  def logged_in!(user=nil)
    @current_user = user || Factory.create(:user)
    controller.stub!(:current_user).and_return(@current_user)
  end

  def admin!(user=nil)
    logged_in!(user)
    @current_user.stub!(:admin?).and_return(true)
  end

end
