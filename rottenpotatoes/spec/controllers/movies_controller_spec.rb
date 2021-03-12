require 'rails_helper'
require 'support/action_controller_workaround.rb'

describe MoviesController do
    describe 'Searching movies with the same director name' do
        it 'should get all the movies with the same director name' do
            movie1 = double("movie")
            movie2 = double("movie")
            # movie1.stub(:title).and_return('The Alien')
            movie1.stub(:id).and_return(1)
            movie2.stub(:id).and_return(2)
            movie1.stub(:title).and_return("The alla")
            movie2.stub(:title).and_return("The bella")
            movie1.stub(:director).and_return("John Doe")
            movie2.stub(:director).and_return("John Doe")
            get :search, {id: 1}
            # expect(response).to render_template(search_directors_path)
        end
    end
end