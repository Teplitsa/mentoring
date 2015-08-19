require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

RSpec.describe MeetingsController, :type => :controller do

  before :each do
    @mentor =  create :user, :mentor
    @curator = create :user, :curator
    @admin =  create :user, :admin
    @user = create :user

    @orphanage = create :orphanage
    @child = create :child, orphanage_id: @orphanage.id, mentor_id: @mentor.id
    @meeting = create :meeting, mentor_id: @mentor.id, child_id: @child.id
  end

  # This should return the minimal set of attributes required to create a valid
  # Meeting. As you add validations to Meeting, be sure to
  # adjust the attributes here as well.
  let :valid_attributes do
    {   date: 4.days.since,
        child_id: Child.last.id,
        mentor_id: Child.last.mentor.id }
  end

  let :invalid_attributes do
    {   date: 4.days.since,
        child_id: Child.last.id,
        mentor_id: 'k' }
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # MeetingsController. Be sure to keep this updated too.
  let(:valid_session) { {} }


  describe '#index' do
    context 'when user is found' do
      it 'sign in' do
        login_user(@user)
        get :index
        expect(response.status).to eq(302)
        expect(response).to_not render_template('index')
      end

      it 'sign in as mentor' do
        login_user(@mentor)
        get :index
        expect(response.status).to eq(200)
        expect(response).to render_template('index')
      end
    end

    context 'when user is not found' do
      it 'without token' do
        get :index
        expect(response.status).to eq(302)
        expect(response).to redirect_to('/users/sign_in')
      end
    end
  end

  describe '#show' do
    context 'when user is found' do
      it 'sign in' do
        login_user(@user)
        get :show, id: @meeting.id
        expect(response.status).to eq(302)
        expect(response).to_not render_template('show')
      end

      it 'sign in as mentor' do
        login_user(@mentor)
        get :show, id: @meeting.id
        expect(response.status).to eq(200)
        expect(response).to render_template('show')
      end
    end

    context 'when user is not found' do
      it 'without token' do
        get :show, id: @meeting.id
        expect(response.status).to eq(302)
        expect(response).to redirect_to('/users/sign_in')
      end
    end
  end

  describe '#new' do
    context 'when user is found' do
      it 'sign in' do
        login_user(@user)
        get :new
        expect(response.status).to eq(302)
        expect(response).to_not render_template('new')
      end

      it 'sign in as mentor' do
        login_user(@mentor)
        get :new
        expect(response.status).to eq(200)
        expect(response).to render_template('new')
      end
    end

    context 'when user is not found' do
      it 'without token' do
        get :new
        expect(response.status).to eq(302)
        expect(response).to redirect_to('/users/sign_in')
      end
    end
  end

=begin
  describe "GET edit" do
    it "assigns the requested meeting as @meeting" do
      meeting = Meeting.create! valid_attributes
      get :edit, {:id => meeting.to_param}, valid_session
      expect(assigns(:meeting)).to eq(meeting)
    end
  end
=end

  describe '#create' do
    context 'with valid params' do
      it 'creates a new Meeting' do
        login_user(@mentor)
        expect {
          post :create, meeting: valid_attributes
        }.to change(Meeting, :count).by(1)
      end

      it 'assigns a newly created meeting as @meeting' do
        login_user(@mentor)
        post :create, meeting: valid_attributes
        expect(assigns(:meeting)).to be_a(Meeting)
        expect(assigns(:meeting)).to be_persisted
      end

      it 'redirects to the created meeting' do
        login_user(@mentor)
        post :create, meeting: valid_attributes
        expect(response).to redirect_to(Meeting.last)
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved meeting as @meeting' do
        login_user(@mentor)
        post :create, meeting: invalid_attributes
        expect(assigns(:meeting)).to be_a_new(Meeting)
      end

      it "re-renders the 'new' template" do
        login_user(@mentor)
        post :create, meeting: invalid_attributes
        expect(response).to render_template('new')
      end
    end
  end

=begin
  describe 'PUT update' do
    describe 'with valid params' do
      let(:new_attributes) {
        skip('Add a hash of attributes valid for your model')
      }

      it 'updates the requested meeting' do
        meeting = Meeting.create! valid_attributes
        put :update, {:id => meeting.to_param, :meeting => new_attributes}, valid_session
        meeting.reload
        skip('Add assertions for updated state')
      end

      it 'assigns the requested meeting as @meeting' do
        meeting = Meeting.create! valid_attributes
        put :update, {:id => meeting.to_param, :meeting => valid_attributes}, valid_session
        expect(assigns(:meeting)).to eq(meeting)
      end

      it 'redirects to the meeting' do
        meeting = Meeting.create! valid_attributes
        put :update, {:id => meeting.to_param, :meeting => valid_attributes}, valid_session
        expect(response).to redirect_to(meeting)
      end
    end

    describe 'with invalid params' do
      it 'assigns the meeting as @meeting' do
        meeting = Meeting.create! valid_attributes
        put :update, {:id => meeting.to_param, :meeting => invalid_attributes}, valid_session
        expect(assigns(:meeting)).to eq(meeting)
      end

      it "re-renders the 'edit' template" do
        meeting = Meeting.create! valid_attributes
        put :update, {:id => meeting.to_param, :meeting => invalid_attributes}, valid_session
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE destroy' do
    it 'destroys the requested meeting' do
      meeting = Meeting.create! valid_attributes
      expect {
        delete :destroy, {:id => meeting.to_param}, valid_session
      }.to change(Meeting, :count).by(-1)
    end

    it 'redirects to the meetings list' do
      meeting = Meeting.create! valid_attributes
      delete :destroy, {:id => meeting.to_param}, valid_session
      expect(response).to redirect_to(meetings_url)
    end
  end
=end

  describe '#reject' do
    it 'rejects the requested meeting as @meeting' do
      login_user(@mentor)
      meeting = Meeting.create! valid_attributes
      get :reject, {:id => meeting.to_param}, valid_session
      expect(assigns(:meeting).state).to eq('rejected')
    end
  end

  describe '#reopen' do
    it 'reopens the requested meeting as @meeting' do
      login_user(@mentor)
      meeting = Meeting.create! valid_attributes
      meeting.reject!
      get :reopen, {:id => meeting.to_param}, valid_session
      expect(assigns(:meeting).state).to eq('new')
    end
  end

end