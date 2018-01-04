Feature: Search Products
  Users should be able to search for products

  Scenario: As a customer I can search the products with keywords
    Given I go to the URL "https://staging.therealreal.com/products"
    When I enter "Guccissima High-Top Sneakers" into the search input
    And I press RETURN
    Then I wait up to 30 seconds for the page title to be "Guccissima High-Top Sneakers"
    And the current URL should contain "/products?keywords=Guccissima%20High-Top%20Sneakers"
    And each product description should contain part of "Guccissima High-Top Sneakers"
