# name: discourse-images-guardian
# about: Discourse plugin that would prevent non-authenticated users from accessing uploaded images
# version: 0.1
# authors: Muhlis Budi Cahyono (muhlisbc@gmail.com)
# url: https://github.com/momon/discourse-images-guardian

enabled_site_setting :images_guardian_enabled

after_initialize {

  require_dependency "session_controller"
  class ::SessionController
    
    after_action :set_images_guardian_cookie

    def set_images_guardian_cookie
      igc_val, igc_exp = ((!SiteSetting.images_guardian_enabled || (SiteSetting.images_guardian_enabled && current_user)) ? [ENV["IGUARD_COOKIE"], 1.year.from_now] : ["", 1.year.ago])

      cookies[:iguard] = {value: igc_val, expires: igc_exp}
    end

  end

}