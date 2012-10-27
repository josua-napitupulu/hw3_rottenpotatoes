# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  Movie.delete_all
  movies_table.hashes.each do |movie|
    movies_table.hashes.each do |movie|
      Movie.new(movie).save
    end
  end
  visit path_to("the RottenPotatoes home page")
end

And /I am on (.+)$/ do |page_name|
  current_path = URI.parse(current_url).path
  if current_path.respond_to? :should
    current_path.should == path_to(page_name)
  else
    assert_equal path_to(page_name), current_path
  end
end

When I follow "Movie Title"

end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.content  is the entire content of the page as a string.
  flunk "Unimplemented"
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  list = rating_list.split(",")
  list.each do |field|
    if uncheck
      uncheck("ratings[" + field.strip + "]")
    else
      check("ratings[" + field.strip + "]")
    end
  end
end

And /^(?:|I )press "([^"]*)"$/ do |button|
  click_button(button)
end

Then /I should only see movies with following ratings: (.*)/ do |rating_list|
  list = rating_list.split(", ")
  table_count = page.all('table#movies tr').count - 1
  movie_count = Movie.where(:rating => list).count()
  assert table_count == movie_count
#, "table count ("+ table_count.to_s +") doesn't match movie count("+ movie_count.to_s +")"
end

When /I (un)?check all the ratings/ do |uncheck|
  movies = Movie.all
  movies.each do |movie|
    if uncheck
      uncheck("ratings[" + movie.rating + "]")
    else
      check("ratings[" + movie.rating + "]")
    end
  end
end

Then /I should see (all|none) of the movies/ do |all|
  table_count = page.all('table#movies tr').count - 1
  if all
    movie_count = Movie.all.count
  else
    movie_count = 0
  end
  assert table_count == movie_count
#, "table count ("+ table_count.to_s +") doesn't match movie count("+ movie_count.to_s +")"
end
