class Api::V1::DevicesController < Api::BaseController

  def create
    @device = current_user.devices.create(device_params)

    if @device.save
      respond_to do |format|
        format.json do
          render action: 'show',
                 status: :created,
                 location: api_v1_device_path(@device, format: :json)
        end
      end
    else
      respond_to do |format|
        format.json do
          render json: Api::Error::InvalidRecord.new( @device.errors.full_messages.join(',') ),
                 status: :unprocessable_entity
        end
      end
    end
  end

  private

  def device_params
    params.require(:device).permit(:notification_token)
  end

end
