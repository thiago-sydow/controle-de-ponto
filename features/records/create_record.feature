Feature: Create Record
  As a registered user of the website
  I want to include a new record

  Scenario: Redirect to Create Record page
    Given I am logged in
    When I am in the records listing page
    And  I click in the new button
    Then I should be in the create record page

  Scenario: Create a new normal Record
    Given I am logged in
    And I am in the create record page
    When I click in the submit button
    Then I should be in the records listing page
    And I should see a successful creation message

  Scenario: Create a new Extra Hour Record
    Given I am logged in
    And I am in the create record page
    When I change type to extra hour
    And I click in the submit button
    Then I should be in the records listing page
    And I should see a successful creation message
