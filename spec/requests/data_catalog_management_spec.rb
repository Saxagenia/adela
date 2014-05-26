require 'spec_helper'

feature "data catalog management" do
  
  background do
    @organization = FactoryGirl.create(:organization)
    @empty_response = []
  end

  scenario "can consume published catalog data" do
    given_there_is_a_catalog_published 10.days.ago
    get "/#{@organization.slug}/catalogo.json"
    gets_catalog_json_data_in response
  end

  scenario "can't consume unpublished catalog data" do
    given_there_is_an_inventary_by("CONEVAL", "unpublished")
    get "/coneval/catalogo.json"
    gets_empty response
  end

  scenario "can see all the catalogs available through the api" do
    given_there_is_an_inventary_by("CONEVAL", "published")
    given_there_is_an_inventary_by("Presidencia", "published")
    given_there_is_an_inventary_by("Hacienda", "unpublished")
    get "/api/v1/organizations/catalogs.json"
    gets_all_catalogs_urls_in response
  end

  def given_there_is_a_catalog_published(days_ago)
    @inventory = FactoryGirl.create(:published_inventory, :publish_date => days_ago)
    @inventory.update_attributes(:organization_id => @organization.id)
  end

  def gets_catalog_json_data_in(response)
    json_response = JSON.parse(response.body)
    json_response[0]["distributions"].size == 3
    json_response[1]["distributions"].size == 4
  end

  def gets_empty(response)
    json_response = JSON.parse(response.body)
    json_response.should == @empty_response
  end

  def given_there_is_an_inventary_by(organization_title, status)
    organization = FactoryGirl.create(:organization, :title => organization_title)
    case status
    when "published"
      inventory = FactoryGirl.create(:published_inventory)
    when "unpublished"
      inventory = FactoryGirl.create(:inventory)
    end
    inventory.update_attributes(:organization_id => organization.id)
  end

  def gets_all_catalogs_urls_in(response)
    json_response = JSON.parse(response.body)
    json_response.size.should == 2
  end
end