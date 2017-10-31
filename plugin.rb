# name: discourse-images-guardian
# about: Discourse plugin that would prevent non-authenticated users from accessing uploaded images
# version: 0.1
# authors: Muhlis Budi Cahyono (muhlisbc@gmail.com)
# url: https://github.com/momon/discourse-images-guardian

enabled_site_setting :images_guardian_enabled

after_initialize {

  require_dependency "application_controller"
  class ::ApplicationController
    
    after_action :set_images_guardian_cookie

    def set_images_guardian_cookie
      if (!SiteSetting.images_guardian_enabled || (SiteSetting.images_guardian_enabled && current_user))
        cookies[:iguard] = {value: ENV["IGUARD_COOKIE"], expires: 1.week.from_now}
      else
        cookies[:iguard] = {value: "", expires: 1.year.ago}
      end      
    end

  end

}