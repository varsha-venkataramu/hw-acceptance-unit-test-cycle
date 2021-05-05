require 'rails_helper'

RSpec.describe MoviesController, type: :controller do
    render_views

    describe 'Create Movie' do
        movie_params = {:title => 'random title', :director => 'imaginary director', :rating => 'R', :description => 'random', :release_date => '6-Apr-1968'}
        let!(:movie) {Movie.create(movie_params)}
    
        it 'should create a movie' do
          expect(Movie).to receive(:create!).with(movie_params).and_return(movie)
          post :create, movie: movie_params
          expect(flash[:notice]).to match(/was successfully created/)
          expect(response).to redirect_to(movies_path)
        end
      end

    describe 'Delete movie' do
        movie_params = {:title => 'random title', :director => 'imaginary director', :rating => 'R', :description => 'random', :release_date => '6-Apr-1968'}
        let!(:movie) {Movie.create(movie_params)}
    
        it 'should set the flash' do
          delete :destroy, {id: movie.id}
          expect(flash[:notice]).to match(/deleted/)
          expect(response).to redirect_to(movies_path)
        end
      end
  
      describe 'Edit Movie' do
        let!(:movie) { Movie.create({:title => 'Catch me if you can', :director => 'Steven Spielberg'})}
    
        it 'should get edit page for movie' do
          get :edit, id: movie.id
          expect(response).to render_template('edit')
        end
      end
    
    describe 'Get Index' do
    it 'should get index' do
      get :index
      expect(response).to render_template('index')
    end
  end

  describe 'Update Movie' do
    let!(:movie) { Movie.create({:title => 'Catch me if you can', :director => 'Steven Spielberg'})}

    it 'should update the details' do
      put :update, {id: movie.id, :movie => {'director' => 'another name'}}
      expect(flash[:notice]).to match(/was successfully updated/)
      expect(response).to redirect_to(movie_path)
    end
  end
  
    describe 'search for similar movie' do
        let!(:m1) { FactoryGirl.create(:movie, title: 'The Terminator', director: 'This guy') }
        let!(:m2) { FactoryGirl.create(:movie, title: 'When Harry Met Sally', director: 'This guy') }


        it 'calls similar movies' do 
            expect(Movie).to receive(:search_by_director).with('The Terminator')
            get :search, { title: 'The Terminator' } 
        end

        it 'gets similar movies' do
            movie_list = [m1, m2]
            movie_names = ["The Terminator", "When Harry Met Sally"]
            Movie.stub(:search_by_director).with('The Terminator').and_return(movie_list)
            # Movie.search_by_director('The Terminator').should be(movie_list)
            # expect(Movie.search_by_director('The Terminator')).to eq(movie_list)
            # movies = Movie.search_by_director('Before Sunrise')
            get :search, { title: 'The Terminator' }
            # assigns(:search_by_director).each do |movie| 
            #     # $stderr.puts("sahdjhd", movie.title)
            #     Rails.logger.debug movie.inspect
            #     expect(movie.title).to match_array(movie_names)
            # end
            # puts("hulu", response.headers)
            movie_names.each do |movie|
                expect(response.body).to have_content(movie)
            end
        end


        it "redirect to home if nil" do
            Movie.stub(:search_by_director).with('Random Name').and_return(nil)
            get :search, { title: 'Random Name' }
            expect(response).to redirect_to(root_url) 
        end
        # it 'should assign similar movies if director exists' do
        #   movies = ['Seven', 'The Social Network']
        #   Movie.stub(:similar_movies).with('Seven').and_return(movies)
        #   get :search, { title: 'Seven' }
        #   expect(assigns(:similar_movies)).to eql(movies)
        # end
    end
end