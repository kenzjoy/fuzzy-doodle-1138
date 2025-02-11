require 'rails_helper'

RSpec.describe 'mechanics show page (/mechanics/:id)' do
  describe 'as a user' do
    describe 'when I visit the mechanic show page' do
      before :each do
        @flags = AmusementPark.create!(name: "Six Flags", admission_cost: 75)

        @kara = Mechanic.create!(name: "Kara Smith", years_experience: 11)
        @larry = Mechanic.create!(name: "Larry Quinn", years_experience: 3)

        @frog = @flags.rides.create!(name: "The Frog Hopper", thrill_rating: 7, open: false)
        @farenheit = @flags.rides.create!(name: "Farenheit", thrill_rating: 9, open: true)
        @kiss = @flags.rides.create!(name: "The Kiss Raise", thrill_rating: 4, open: true)

        @kara.rides << @frog
        @kara.rides << @farenheit
        @kara.rides << @kiss
        @larry.rides << @farenheit
        @larry.rides << @kiss 
      end

      it '- shows their name, years of experience, and the names of all the rides they are working on' do
        visit mechanic_path(@kara)

        expect(page).to have_content("Mechanic Name: #{@kara.name}")
        expect(page).to have_content("Years of Experience: #{@kara.years_experience}")
        expect(page).to_not have_content("Years of Experience: #{@larry.name}")
        expect(page).to_not have_content("Years of Experience: #{@larry.years_experience}")

        within "#mechanic-rides" do
          expect(page).to have_content("The Frog Hopper")
          expect(page).to have_content("Farenheit")
          expect(page).to have_content("The Kiss Raise")
        end
      end

      it '- shows a form to add a ride to their workload' do
        visit mechanic_path(@larry)

        expect(page).to have_content("Add a ride to workload:")
        expect(page).to have_selector(:css, "form")
        expect(page).to have_field(:ride_id)
        expect(page).to have_button("Submit")
      end

      it '- when I fill in that field with an id of an existing ride and click Submit,
      I am taken back to that mechanics show page and I see the name of that newly added
      ride on this mechanics show page' do
        visit mechanic_path(@larry)

        fill_in("Ride id:", with: "#{@frog.id}")
        click_on("Submit")
        expect(current_path).to eq(mechanic_path(@larry))

        within "#mechanic-rides" do
          expect(page).to have_content("The Frog Hopper")
        end
      end
    end
  end
end