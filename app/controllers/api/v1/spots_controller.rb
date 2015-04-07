class Api::V1::SpotsController < Api::BaseController

  def create
    @spot = Spot.new(spot_params)

    # check if image was sent
    if params[:spot] && params[:spot][:image_data]
      image_data = params[:spot].delete(:image_data)
      decoded_image_data = Base64.decode64(image_data)
      decoded_image_file = Tempfile.new("fileupload")
      decoded_image_file.binmode
      decoded_image_file.write(decoded_image_data)

      # If we don't rewind, the file cursor will be at the end of the file, and there
      # will be nothing left to read (making the server think the file is empty)
      decoded_image_file.rewind

      # assume the mime-type is jpeg, if the actual file type doesn't match, the
      # controller will blow up.
      mime_type = 'image/jpeg'

      # Previously we were ascertaining the mimetype from the contents of the
      # file using the ruby-filemagic gem but the FileMagic gem does not
      # install on Heroku. - mjk 2014/5/30
      # mime_type = FileMagic.new(FileMagic::MAGIC_MIME).file(decoded_image_file.path)

      # create a new uploaded file
      uploaded_file = ActionDispatch::Http::UploadedFile.new(
        :tempfile => decoded_image_file,
        :filename => Spot.generate_image_filename,
        :type => mime_type
      )

      @spot.image = uploaded_file
    end

    respond_to do |format|
      if @spot.save
        format.json { render action: 'show', status: :created, location: api_v1_spot_path(1, @spot, format: :json) }
      else
        format.json { render json: { error: @spot.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  def index
    @spots = Spot.all
    respond_to do |format|
      format.json { render :index }
    end
  end

  def show
    @spot = Spot.find(params[:id])
    respond_to do |format|
      format.json { render :show }
    end
  end

  private

  def spot_params
    params.require(:spot).permit(location: [ :type, coordinates: [] ])
  end

end
