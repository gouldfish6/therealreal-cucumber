# Element Selectors
# Header
$page_title = "h1"
$search_input = ".navigation-container #search"
$item_count = ".plp-description__item-count"
$sort_drop_down = "#product_search_order"

# Filters
$filter_title = ".search-category-title"
$filter_link = ".taxon-filter-link"
$filter_box = ".product-filters__box-label"
$price_from_filter = "[name=current_price_from]"
$price_to_filter = "[name=current_price_to]"
$designer_filter = ".search-filter-list-label-name"
$reset_categories_filter_link = ".reset-links"
$reset_other_filter_link = ".search-filter-reset"

# Products
$product_card = ".js-product-card"
$product_image = ".product-card__image"
$product_brand = ".product-card__brand"
$product_description = ".product-card__description"
$product_size = ".product-card__sizes :first-child"
$product_price = ".product-card__price"
$product_discount_by_position = "(//div[@class='product-search-form"\
    "__results-item product-card js-product-card'])[%d]//div[@class='product"\
    "-card__grid-discount']"
$product_link = ".product-card__details a"
$obsess_checkbox = ".obsess-box__icon"
$product_sold_overlay = ".product-card__status-label--sold"

# Product details page
$product_name = ".product-title__name"

# Step Definitions
Given(/^I go to the URL "(.*?)"$/) do |target_url|
    $driver.get target_url
end

When(/^I enter "(.*?)" into the search input$/) do |text|
    search_input = $driver.find_element(:css, $search_input)
    search_input.send_keys text
end

When(/^I press RETURN$/) do
    $driver.action.send_keys("\n").perform
end

When(/^I select "(.*?)" from the sort drop down list$/) do |dropdown_text|
    drop_down = $driver.find_element(:css, $sort_drop_down)
    Selenium::WebDriver::Support::Select.new(drop_down).select_by(
        :text, dropdown_text)
end

When(/^I click the filter title that contains the text "([^\"]*)"$/) do |title_text|
    filter_titles = $driver.find_elements(:css, $filter_title)
    filter_titles.each {
        |filter_title|
        if filter_title.text.downcase.include? title_text.downcase
            filter_title.click
            break
        end
    }
end

When(/^I click the filter link that contains the text "([^\"]*)"$/) do |link_text|
    filter_links = $driver.find_elements(:css, $filter_link)
    filter_links.each {
        |filter_link|
        if filter_link.text.downcase.include? link_text.downcase
            filter_link.click
            break
        end
    }
end

When(/^I click the filter box that contains the text "([^\"]*)"$/) do |box_text|
    filter_boxes = $driver.find_elements(:css, $filter_box)
    filter_boxes.each {
        |filter_box|
        if filter_box.text.downcase.include? box_text.downcase
            filter_box.click
            break
        end
    }
end

When(/^I enter the price filter from (.*?) to (.*?)$/) do |low_price, high_price|
    $driver.find_element(:css, $price_from_filter).send_keys low_price
    $driver.find_element(:css, $price_to_filter).send_keys high_price
end

When(/^I click the designer filter that contains the text "([^\"]*)"$/) do |brand_name|
    designer_filters = $driver.find_elements(:css, $designer_filter)
    designer_filters.each {
        |designer_filter|
        if designer_filter.text == brand_name
            designer_filter.click
            break
        end
    }
end

When(/^I click the product card that contains the description "([^\"]*)"$/) do |expected_description|
    descriptions = $driver.find_elements(:css, $product_description)
    descriptions.each {
        |description|
        if description.text.include? expected_description
            description.click
            break
        end
    }
end

Then(/^I wait up to (\d+) seconds for the page title to be "([^\"]*)"$/) do |wait_time, expected_text|
    wait = Selenium::WebDriver::Wait.new(:timeout => wait_time.to_i)
    wait.until {
        title = $driver.find_element(:css, $page_title).text
        title.downcase == expected_text.downcase ? true : false
    }
end

Then(/^I wait up to (\d+) seconds for a product to be visible$/) do |wait_time|
    wait = Selenium::WebDriver::Wait.new(:timeout => wait_time.to_i)
    wait.until {
        $driver.find_element(:css, $product_description).displayed?
    }
end

Then(/^I wait up to (\d+) seconds for the first product description to contain the text "([^\"]*)"$/) do |wait_time, expected_text|
    wait = Selenium::WebDriver::Wait.new(:timeout => wait_time.to_i)
    wait.until {
        first_description = $driver.find_element(:css, $product_description).text
        first_description.include? expected_text
    }
end

Then(/^I wait up to (\d+) seconds for the categories reset filter link to be shown$/) do |wait_time|
    wait = Selenium::WebDriver::Wait.new(:timeout => wait_time.to_i)
    wait.until {
        $driver.find_element(:css, $reset_categories_filter_link).displayed?
    }
end

Then(/^I wait up to (\d+) seconds for the other reset filter link to be shown$/) do |wait_time|
    wait = Selenium::WebDriver::Wait.new(:timeout => wait_time.to_i)
    wait.until {
        $driver.find_element(:css, $reset_other_filter_link).displayed?
    }
end

Then(/^I wait up to (\d+) seconds for the first product to be sold$/) do |wait_time|
    wait = Selenium::WebDriver::Wait.new(:timeout => wait_time.to_i)
    wait.until {
        product_card = $driver.find_element(:css, $product_card)
        begin
            sold = product_card.find_element(:css, $product_sold_overlay)
            true
        rescue Selenium::WebDriver::Error::NoSuchElementError
            false
        end
    }
end

Then(/^the current URL should contain "(.*?)"$/) do |expected_text|
    expect($driver.current_url).to include(expected_text)
end

Then(/^each product description should contain part of "([^\"]*)"$/) do |expected_text|
    product_descriptions = $driver.find_elements(:css, $product_description)
    expected_tokens = expected_text.split
    product_descriptions.each {
        |description|
        found = false
        expected_tokens.each {
            |token|
            if description.text.downcase.include? token.downcase
                found = true
                break
            end
        }
        expect(found).to eq true
    }
end

Then(/^the products should be sorted by ascending price$/) do
    product_prices = $driver.find_elements(:css, $product_price)
    previous_price = -1
    for index in 0..product_prices.length - 1
        begin
            discount_element = $driver.find_element(
                :xpath, $product_discount_by_position % [index + 1])
            discount_price = discount_element.text.partition('$').last.sub(",", "").to_f
            expect(discount_price).to be >= previous_price
            previous_price = discount_price
        rescue Selenium::WebDriver::Error::NoSuchElementError
            price = product_prices[index].text.partition('$').last.sub(",", "").to_f
            expect(price).to be >= previous_price
            previous_price = price
        end
    end
end

Then(/^the products should be sorted by descending price$/) do
    product_prices = $driver.find_elements(:css, $product_price)
    previous_price = product_prices[0].text.partition('$').last.sub(",", "").to_f + 1
    for index in 0..product_prices.length - 1
        begin
            discount_element = $driver.find_element(
                :xpath, $product_discount_by_position % [index + 1])
            discount_price = discount_element.text.partition('$').last.sub(",", "").to_f
            expect(discount_price).to be <= previous_price
            previous_price = discount_price
        rescue Selenium::WebDriver::Error::NoSuchElementError
            price = product_prices[index].text.partition('$').last.sub(",", "").to_f
            expect(price).to be <= previous_price
            previous_price = price
        end
    end
end

Then(/^the products should be sorted by sold products first$/) do
    product_cards = $driver.find_elements(:css, $product_card)
    previous_product_sold = true
    product_cards.each {
        |product_card|
        begin
            sold = product_card.find_element(:css, $product_sold_overlay)
            expect(previous_product_sold).to eq(true)
        rescue Selenium::WebDriver::Error::NoSuchElementError
            previous_product_sold = false
        end
    }
end

Then(/^the products should all be in the "([^\"]*)" filter$/) do |filter_name|
    product_links = $driver.find_elements(:css, $product_link)
    product_links.each {
        |product_link|
        expect(product_link.attribute("href").downcase).to include(
            filter_name.downcase)
    }
end

Then(/^the products should all be size "([^\"]*)" or "One Size"$/) do |expected_size|
    product_sizes = $driver.find_elements(:css, $product_size)
    product_sizes.each {
        |product_size|
        valid_size = product_size.text == expected_size || product_size.text == "One Size"
        expect(valid_size).to eq(true)
    }
end

Then(/^the products should all have a price in the range ([^\"]*) to ([^\"]*)$/) do |low_price, high_price|
    product_prices = $driver.find_elements(:css, $product_price)
    for index in 0..product_prices.length - 1
        begin
            discount_element = $driver.find_element(
                :xpath, $product_discount_by_position % [index + 1])
            discount_price = discount_element.text.partition('$').last.sub(",", "").to_f
            expect(discount_price).to be <= high_price.to_f
            expect(discount_price).to be >= low_price.to_f
        rescue Selenium::WebDriver::Error::NoSuchElementError
            price = product_prices[index].text.partition('$').last.sub(",", "").to_f
            expect(price).to be <= high_price.to_f
            expect(price).to be >= low_price.to_f
        end
    end
end

Then(/^the products should all have the brand "([^\"]*)"$/) do |expected_designer|
    product_brands = $driver.find_elements(:css, $product_brand)
    product_brands.each {
        |product_brand|
        expect(product_brand.text).to eq(expected_designer)
    }
end

Then(/^each product should have two images$/) do
    product_cards = $driver.find_elements(:css, $product_card)
    product_cards.each {
        |product_card|
        images = product_card.find_elements(:css, $product_image)
        expect(images.length).to eq(2)
    }
end

Then(/^each product should have a brand$/) do
    product_cards = $driver.find_elements(:css, $product_card)
    product_cards.each {
        |product_card|
        brand = product_card.find_element(:css, $product_brand)
        expect(brand.text).to be_truthy
    }
end

Then(/^each product should have a description$/) do
    product_cards = $driver.find_elements(:css, $product_card)
    product_cards.each {
        |product_card|
        description = product_card.find_element(:css, $product_description)
        expect(description.text).to be_truthy
    }
end

Then(/^each product should have a price$/) do
    product_cards = $driver.find_elements(:css, $product_card)
    product_cards.each {
        |product_card|
        price = product_card.find_element(:css, $product_price)
        expect(price.text).to be_truthy
    }
end

Then(/^each product should have an obsess checkbox$/) do
    product_cards = $driver.find_elements(:css, $product_card)
    product_cards.each {
        |product_card|
        checkbox = product_card.find_element(:css, $obsess_checkbox)
        expect(checkbox.displayed?).to eq(true)
    }
end
