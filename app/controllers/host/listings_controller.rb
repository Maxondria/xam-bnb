class Host::ListingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_listing, only: %i[show edit update destroy]

  def index
    @listings =
      current_user
        .listings
        .where.not(status: :archived)
        .order(created_at: :desc)
  end

  def show
  end

  def new
    @listing = Listing.new
  end

  def edit
  end

  def update
    if @listing.update(update_listing_params)
      redirect_to host_listing_path(@listing),
                  notice: "Listing was successfully updated."
    else
      flash.now[:alert] = @listing.errors.full_messages.to_sentence
      render :edit
    end
  end

  def create
    @listing = current_user.listings.new(create_listing_params)

    if @listing.save
      redirect_to host_listing_path(@listing),
                  notice: "Listing was successfully created."
    else
      flash.now[:alert] = @listing.errors.full_messages.to_sentence
      render :new
    end
  end

  def destroy
    if @listing.update(status: :archived)
      redirect_to host_listings_path,
                  notice: "Listing was successfully deleted."
    else
      flash.now[:alert] = @listing.errors.full_messages.to_sentence
      render :show
    end
  end

  private

  def create_listing_params
    params.require(:listing).permit(
      :title,
      :about,
      :max_guests,
      :address_line1,
      :address_line2,
      :city,
      :state,
      :postal_code,
      :country
    )
  end

  def update_listing_params
    params.require(:listing).permit(:title, :about, :max_guests)
  end

  def set_listing
    @listing = current_user.listings.find(params[:id])
  end
end
