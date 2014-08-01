When(/^I am in the records listing page$/) do
  visit records_path
end

When(/^I click in the new button$/) do
  create_new_record = I18n.t('helpers.links.new')
  click_link create_new_record
end

Then(/^I should be in the create record page$/) do
  expect(page.current_path).to eq new_record_path
end

And(/^I am in the create record page$/) do
  visit new_record_path
end

When(/^I click in the submit button$/) do
  click_button "Registro"
end

Then(/^I should be in the records listing page$/) do
  expect(page.current_path).to eq records_path
end

And(/^I should see a successful creation message$/) do
  expect(page).to have_content "O registro foi criado com sucesso."
end

When(/^I change type to extra hour$/) do
  choose('Hora Extra')
end