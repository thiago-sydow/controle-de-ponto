shared_context 'a not authorized request' do
  it { expect(response).to have_http_status(:found) }
  it { expect(response).to redirect_to new_user_session_url }
end
