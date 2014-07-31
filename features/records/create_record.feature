Feature: Create Record
  As a registered user of the website
  I want to include a new record

  Scenario: Redirect to Create Record page
    Given I am logged in
    When I am in the records listing page
    And  I click in the new button
    Then I should be in the create record page