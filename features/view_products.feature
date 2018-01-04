Feature: View Products
  Users should be able to view products

  Scenario: As a customer I can see product details
    When I go to the URL "https://staging.therealreal.com/products"
    And I wait up to 30 seconds for a product to be visible
    Then each product should have two images
    And each product should have a brand
    And each product should have a description
    And each product should have a price
    And each product should have an obsess checkbox

  Scenario: As a customer I can click products to see their details
    When I go to the URL "https://staging.therealreal.com/phoenix/products?keywords=embossed%20wrap%20around%20belt%20fendi"
    And I wait up to 30 seconds for the first product description to contain the text "Embossed Wrap Around Belt"
    And I click the product card that contains the description "Embossed Wrap Around Belt"
    Then I wait up to 30 seconds for the page title to be "Fendi Embossed Wrap Around Belt"
