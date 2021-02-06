require 'rails_helper'

describe DayRecordsController do
  let!(:user) { create(:user) }
  let!(:account) { user.current_account }

  describe '#index' do
    let!(:day) { create(:day_record, account: account) }

    context 'when user is logged in' do
      login_user

      before { get :index }

      it { expect(response).to have_http_status(:ok) }
      it { expect(assigns(:day_records)).to eq([day]) }
      it { expect(response).to render_template(:index) }

      context 'when date range is provided' do
        let!(:day_2) { create(:day_record, account: account, reference_date: 2.days.ago) }
        let!(:day_3) { create(:day_record, account: account, reference_date: 3.days.ago) }

        context 'and covers all dates' do
          before { get :index, params: { from: 3.days.ago.to_s } }

          it { expect(assigns(:day_records)).to match_array [day, day_2, day_3] }
          it { expect(assigns(:balance_period).hour).to eq day.balance.sum(day_2.balance).sum(day_3.balance).hour }
          it { expect(assigns(:balance_period).minute).to eq day.balance.sum(day_2.balance).sum(day_3.balance).minute }
        end

        context 'and excludes recent day_records' do
          before { get :index, params: { from: 3.days.ago.to_s, to: 2.days.ago.to_s } }
          it { expect(assigns(:day_records)).to match_array [day_2, day_3] }
        end

        context 'and excludes older day_records' do
          before { get :index, params: { from: 1.days.ago.to_s, to: Time.current.to_s } }
          it { expect(assigns(:day_records)).to match_array [day] }
        end

        context 'with invalid date' do
          before { get :index, params: { from: Time.current.to_s, to: '35/05/2015' } }
          it { expect(assigns(:day_records)).to match_array [day] }
        end
      end
    end

    context 'when user is not logged in' do
      before { get :index }
      it_behaves_like 'a not authorized request'
    end
  end

  describe '#edit' do
    let(:day) { create(:day_record, account: account) }

    context 'when user is logged in' do
      login_user

      before { get :edit, params: { id: day.id } }

      it { expect(response).to have_http_status(:ok) }
      it { expect(assigns(:day_record)).to eq(day) }
      it { expect(response).to render_template(:edit) }

      context ' and the record is not from the user' do
        let(:other_day) { create(:day_record) }

        before { get :edit, params: { id: other_day.id } }

        it { expect(response).to be_not_found }
      end
    end

    context 'when user is not logged in' do
      before { get :edit, params: { id: day.id } }
      it_behaves_like 'a not authorized request'
    end
  end

  describe '#new' do
    context 'when user is logged in' do
      login_user

      before { get :new }

      subject(:assigned) { assigns(:day_record) }

      it { expect(response).to have_http_status(:ok) }
      it { expect(response).to render_template(:new) }
      it { expect(assigned).to be_a_new(DayRecord) }
      it { expect(assigned.reference_date).to eq Date.current }
      it { expect(assigned.time_records.size).to eq 1 }
    end

    context 'when user is not logged in' do
      before { get :new }
      it_behaves_like 'a not authorized request'
    end
  end

  describe '#create' do
    let!(:attrs) { attributes_for(:day_record_with_times, account: account) }

    context 'when user is logged in' do
      login_user

      context ' and parameters are right' do
        before { post :create, params: { day_record: attrs } }

        it { expect(response).to redirect_to day_records_path }
        it { expect(flash[:success]).not_to be_nil }
      end

      context ' and parameters are wrong' do
        it { expect { post(:create) }.to raise_error(ActionController::ParameterMissing) }
      end

      context ' and an error occured while creating' do
        before do
          allow_any_instance_of(DayRecord).to receive(:save).and_return(false)
          post :create, params: { day_record: attrs }
        end

        it { expect(response).to render_template(:new) }
        it { expect(flash[:error]).not_to be_nil }
        it { expect(account.day_records.count).to eq(0) }
      end

      context ' and save_and_add is present' do
        before { post :create, params: { day_record: attrs, save_and_add: 'xunda' } }

        it { expect(response).to redirect_to new_day_record_path }
        it { expect(flash[:success]).not_to be_nil }
      end
    end

    context 'when user is not logged in' do
      before { post :create, params: { day_record: attrs } }
      it_behaves_like 'a not authorized request'
    end

  end

  context '#update' do
    let!(:day) { create(:day_record_with_times, account: account) }
    let(:change_id) { day.reload.time_records.first.id }
    let!(:new_time) { Time.current.change(hour: 9, min: 56) }
    let(:attrs) { { time_records_attributes: { '0' => { id: change_id, time: new_time.to_s } } } }

    context 'when user is logged in' do
      login_user

      context ' and parameters are right' do
        before { patch :update, params: { id: day.id, day_record: attrs }; day.reload; }

        it { is_expected.to redirect_to day_records_path }
        it { expect(flash[:success]).not_to be_nil }
        it { expect(day.time_records.find(change_id).time.hour).to eq new_time.hour }
        it { expect(day.time_records.find(change_id).time.min).to eq new_time.min }
      end

      context ' and parameters are wrong' do
        it { expect { patch(:update, params: { id: day.id }) }.to raise_error(ActionController::ParameterMissing) }
      end

      context ' and an error occured while updating' do
        before do
          allow_any_instance_of(DayRecord).to receive(:update).and_return(false)
          patch :update, params: { id: day.id, day_record: attrs }
        end

        it { expect(response).to render_template(:edit) }
        it { expect(flash[:error]).not_to be_nil }
      end

      context ' and the record is not from the user' do
        let(:other_day) { create(:day_record) }

        before do
          patch :update, params: { id: other_day.id, day_record: attrs }
        end

        it { expect(response).to be_not_found }
      end
    end

    context 'when user is not logged in' do
      before { patch :update, params: { id: day.id, day_record: attrs } }
      it_behaves_like 'a not authorized request'
    end
  end

  describe '#destroy' do
    let!(:day) { create(:day_record, account: account) }
    let(:find_day) { DayRecord.find(day.id) }

    context 'when user is logged in' do
      login_user

      context ' and parameters are right' do
        before { delete :destroy, params: { id: day.id } }

        it { is_expected.to redirect_to day_records_path }
        it { expect(flash[:success]).not_to be_nil }
      end

      context ' and parameters are wrong' do
        before { delete :destroy, params: { id: '11111' } }

        it { expect(response).to be_not_found }
      end

      context ' and an error occured while updating' do

        before do
          allow_any_instance_of(DayRecord).to receive(:destroy).and_return(day)
          allow_any_instance_of(DayRecord).to receive(:destroyed?).and_return(false)
          delete :destroy, params: { id: day.id }
        end

        it { expect(response).to redirect_to day_records_path }
        it { expect(flash[:error]).not_to be_nil }
        it { expect(find_day).to eq(day) }
      end

    end

    context 'when user is not logged in' do
      before { delete :destroy, params: { id: day.id } }
      it_behaves_like 'a not authorized request'
    end
  end

  describe '#async_worked_time' do

    context 'when user is logged in' do
      login_user

      let(:time_1) { create(:time_record, time: 3.hours.ago) }
      let!(:day) { create(:day_record, account: account, time_records: [time_1]) }

      before { get :async_worked_time }

      it { expect(JSON.parse(response.body)['time']).to eq '03:00' }
      it { expect(JSON.parse(response.body)['percentage']).to eq 37.5 }
    end

    context 'when user is not logged in' do
      before { get :async_worked_time }
      it_behaves_like 'a not authorized request'
    end
  end

  describe '#add_now' do

    context 'when user is logged in' do
      login_user

      let!(:day) { create(:day_record, account: account) }
      let!(:time_1) { create(:time_record, time: 3.hours.ago, day_record: day) }

      before { post :add_now }

      it { expect(day.reload.time_records.size).to eq 2}
      it { expect(response).to redirect_to day_records_path }
    end

    context 'when user is not logged in' do
      before { post :add_now }
      it_behaves_like 'a not authorized request'
    end
  end

  describe '#export' do

    context 'when user is logged in' do
      login_user

      let!(:day) { create(:day_record, account: account) }
      let!(:time_1) { create(:time_record, time: 3.hours.ago, day_record: day) }
      let(:from) { subject.instance_variable_get(:@from)}
      let(:to) { subject.instance_variable_get(:@to)}
      let(:file_name) { "#{user.first_name} - #{user.current_account.name} - #{from.strftime('%d-%m-%Y')} a #{to.strftime('%d-%m-%Y')}" }

      context 'type PDF' do
        before { get :export, params: { format: 'pdf' } }

        it { expect(response.headers["Content-Type"]).to eq "application/pdf"}
        it { expect(response.headers["Content-Disposition"]).to include "attachment; filename=\"#{file_name}.pdf\"" }
      end

      context 'type XLSX' do
        before { get :export, params: { format: 'xlsx' } }

        it { expect(response.headers["Content-Type"]).to eq "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" }
        it { expect(response.headers["Content-Disposition"]).to include "attachment; filename=\"#{file_name}.xlsx\"" }
      end

      context 'with date range' do
        before { get :export, params: { format: 'pdf', from: 2.days.ago.to_s, to: Date.current.to_s } }

        it { expect(from).to eq 2.days.ago.to_date }
        it { expect(to).to eq Date.current }
      end

    end

    context 'when user is not logged in' do
      before { get :export }
      it_behaves_like 'a not authorized request'
    end
  end

end
