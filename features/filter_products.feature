Feature: Filter Products
  Users should be able to filter products

  Scenario: As a customer I can filter the products by category
    Given I go to the URL "https://staging.therealreal.com/products"
    When I click the filter link that contains the text "Women"
    Then I wait up to 30 seconds for the categories reset filter link to be shown
    And the products should all be in the "Women" filter

  Scenario: As a customer I can filter the products by cothing size
    Given I go to the URL "https://staging.therealreal.com/products"
    When I click the filter title that contains the text "Clothing Sizes"
    And I click the filter box that contains the text "XXL"
    Then I wait up to 30 seconds for the other reset filter link to be shown
    And the products should all be size "XXL" or "One Size"

  Scenario: As a customer I can filter the products by shoe size
    Given I go to the URL "https://staging.therealreal.com/products"
    When I click the filter title that contains the text "Shoe Sizes"
    And I click the filter box that contains the text "12.5"
    Then I wait up to 30 seconds for the other reset filter link to be shown
    And the products should all be size "12.5" or "One Size"

  Scenario: As a customer I can filter the products by price
    Given I go to the URL "https://staging.therealreal.com/products"
    When I click the filter title that contains the text "Price"
    And I enter the price filter from 1000 to 2000
    Then I wait up to 30 seconds for the other reset filter link to be shown
    And the products should all have a price in the range 1000 to 2000

  Scenario: As a customer I can filter the products by designer
    Given I go to the URL "https://staging.therealreal.com/products"
    When I click the filter title that contains the text "Designers"
    And I click the designer filter that contains the text "A.P.C."
    Then I wait up to 30 seconds for the other reset filter link to be shown
    And the products should all have the brand "A.P.C."
