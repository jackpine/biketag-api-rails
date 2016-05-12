class HealthReportsController < ApplicationController

  def show
    Rails.logger.info "Health report requested at #{Time.zone.now}"

    # make sure we can talk to DB
    health_report = {
      all_systems_normal: true,
      created_at: Time.zone.now,
      current_spot_count: Spot.current.count
    }

    Rails.logger.info "Health Report Complete: #{health_report.inspect}"

    respond_to do |format|
      format.json { render json: { health_report: health_report } }
    end
  end

end
