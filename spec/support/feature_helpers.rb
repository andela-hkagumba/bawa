module FeatureHelpers
  def login_user(user, user_email = "email")
    visit "/login"

    within ".form" do
      fill_in("session_email_username",
              with: user[user_email])
      fill_in("session_password", with: user.password)
      check("Remember me")

      click_button("Log in")
    end
  end

  def logout_user
    find(".nav-trigger").trigger("click")
    click_link("Logout")
  end

  def search_for_flight(airport)
    within ".form" do
      fill_in("location_name", with: airport.name)
      fill_in("passengers", with: "2")
      click_button("Search flights")
    end
  end

  def search_for_booking(booking)
    find("span", text: "Manage Bookings").trigger("click")
    within "#manage-bookings-form" do
      fill_in("booking_code", with: booking.booking_code)
      click_button("Search Booking")
    end
  end

  def update_booking
    click_link("Edit")
    fill_in("booking_passengers_attributes_0_first_name",
            with: "Herbert")
    click_button("Update Booking")
  end

  def delete_booking
    find("a", text: "Past bookings").trigger("click")
  end

  def make_passengers(email = Faker::Internet.email)
    fname = Faker::Name.first_name
    lname = Faker::Name.last_name
    fname2 = Faker::Name.first_name
    lname2 = Faker::Name.last_name
    email2 = Faker::Internet.email

    fill_in("booking_passengers_attributes_0_first_name",
            with: fname)
    fill_in("booking_passengers_attributes_0_last_name",
            with: lname)
    fill_in("booking_passengers_attributes_0_email",
            with: email)

    fill_in("booking_passengers_attributes_1_first_name",
            with: fname2)
    fill_in("booking_passengers_attributes_1_last_name",
            with: lname2)
    fill_in("booking_passengers_attributes_1_email",
            with: email2)
  end
end
