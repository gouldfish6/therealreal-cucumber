Feature: Sort Products
  Users should be able to sort products

  Scenario: As a customer I can sort the products from "Price: Low - High"
    Given I go to the URL "https://staging.therealreal.com/products"
    When I select "Price: Low - High" from the sort drop down list
    Then I wait up to 30 seconds for the first product description to contain the text "Boys' Sleeveless Scoop Neck Shirt"
    And the products should be sorted by ascending price

  Scenario: As a customer I can sort the products from "Price: High - Low"
    Given I go to the URL "https://staging.therealreal.com/products"
    When I select "Price: High - Low" from the sort drop down list
    Then I wait up to 30 seconds for the first product description to contain the text "Yellow Diamond Eternity Band"
    And the products should be sorted by descending price

  Scenario: As a customer I can sort the products with sold products first
    Given I go to the URL "https://staging.therealreal.com/products"
    When I select "Sold Items First" from the sort drop down list
    Then I wait up to 30 seconds for the first product to be sold
    And the products should be sorted by sold products first
