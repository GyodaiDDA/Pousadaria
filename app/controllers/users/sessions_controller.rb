class Users::SessionsController < Devise::SessionsController
  protected

  def after_sign_in_path_for(resource)
    if resource.user_type == 'Owner'
      after_owner_sign_in
    elsif resource.user_type == 'Customer'
      after_customer_sign_in
    end
  end

  def after_owner_sign_in
    if resource.inn.blank?
      new_inn_path
    else
      inn_path(current_user.inn)
    end
  end

  def after_customer_sign_in
    if params[:nested_login]
      logger.info "Esse é o reservation_id: #{params[:reservation_id]} e esse é o cu: #{current_user.id}"
      associate_reservation_to_user(params[:reservation_id])
      logger.info 'Passou pelo associate_reservation_to_user'
      stored_location_for(resource) || request.referer || root_path
    elsif session[:codes]
      reservations_retrieve_path
    else
      root_path
    end
  end

  def associate_reservation_to_user(reservation_id)
    reservation = Reservation.find_by(id: reservation_id)
    reservation.update(user_id: current_user.id) if current_user.present?
  end
end
