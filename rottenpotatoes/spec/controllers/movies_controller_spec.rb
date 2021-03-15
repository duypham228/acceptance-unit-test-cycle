require 'rails_helper'
require 'support/action_controller_workaround.rb'
require 'simplecov'
SimpleCov.start 'rails'

describe MoviesController do
    before do
        Movie.new(:id => 1,:title => 'The Alla', :director => 'John Doe', :rating => 'G').save
        Movie.new(:id => 2,:title => 'The Bella', :director => 'John Doe', :rating => 'G').save
        Movie.new(:id => 3,:title => 'The Cella', :director => '', :rating => 'PG-13').save
    end
    
    describe 'Searching movies with the same director name' do
        
        it 'should return the name of director from the movie' do
            movie1 = double(Movie)
            movie1.stub(:id).and_return(1)
            movie1.stub(:title).and_return("The Alla")
            movie1.stub(:director).and_return("John Doe")
            expect(Movie).to receive(:find).with('1').and_return(movie1)
            get :search, { :id => 1 }
        end
        it 'should match all the movies with the same director (happy path)' do
            movies = ['The Alla', 'The Bella']
            get :search, { :id => 1 }
            expect(Movie.movies_same_director("John Doe").pluck(:title)).to eql(movies)
        end
        
        it 'should return to the home page if the movie do not have director (sad path)' do
            get :search, { :id => 3 }
            expect(response).to redirect_to(movies_path)
        end
        
        it 'should show the message no director info if it goes the sad path' do
            get :search, { :id => 3 }
            expect(response.body).to have_content('You are being redirected')
        end
    end
    
    describe 'Rendering The Homepage' do
        # render_views
        it 'should render the index' do
            get :index
            expect(response).to render_template('index')
        end
        
        render_views
        it 'should show all movies' do
            get :index
            expect(response.body).to have_content("The Alla")
            expect(response.body).to have_content("The Bella")
            expect(response.body).to have_content("The Cella")
        end
        
        # it 'should show filtered movies' do
        #     get :index, {:ratings => ['G']}
        #     expect(response.body).to have_no_content("The Cella")
        # end
        
        it 'should change color of  title header when clicked' do
            get :index, {:sort => 'title'}
            expect(assigns(:title_header)).to eql('bg-warning hilite')
        end
        
        it 'should change color of release date header when clicked' do
            get :index, {:sort => 'release_date'}
            expect(assigns(:date_header)).to eql('bg-warning hilite')
        end
    end
end