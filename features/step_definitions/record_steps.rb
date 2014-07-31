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