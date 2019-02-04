# name: discourse-images-guardian
# about: Discourse plugin that would prevent non-authenticated users from accessing uploaded images
# version: 0.2.0
# authors: Muhlis Budi Cahyono (muhlisbc@gmail.com)
# url: https://github.com/momon/discourse-images-guardian

enabled_site_setting :images_guardian_enabled

after_initialize {

  require_dependency "application_controller"
  class ::ApplicationController
    
    after_action :set_images_guardian_cookie

    def set_images_guardian_cookie
      igc_val, igc_exp =  (!SiteSetting.images_guardian_enabled || (SiteSetting.images_guardian_enabled && current_user)) ? [ENV["IGUARD_COOKIE"], 1.week.from_now] : ["", 1.year.ago]
      cookies[:iguard] = {
          value: igc_val,
          expires: igc_exp,
          httponly: true,
          secure: SiteSetting.force_https,
          same_site: :strict
        }
    end

  end

  require_dependency "site_setting"
  class ::SiteSetting
    class << self

      {
        site_home_logo_url: "logo",
        site_logo_url: "logo",
        site_logo_small_url: "logo_small",
        site_digest_logo_url: "digest_logo",
        site_mobile_logo_url: "mobile_logo",
        site_large_icon_url: "large_icon",
        site_favicon_url: "favicon",
        site_apple_touch_icon_url: "apple_touch_icon",
        opengraph_image_url: "opengraph_image",
        site_twitter_summary_large_image_url: "twitter_summary_large_image",
        site_push_notifications_icon_url: "push_notifications_icon"
      }.each do |m, trans|

        I18n.backend.store_translations(:en, {
          site_settings: {
            "images_guardian_#{m}" => I18n.t("site_settings.#{trans}") + " <em>(original setting: <strong>#{trans}</strong>)</em>"
          }
        })

        alias_method "orig_#{m}".to_sym, m

        define_method(m) do
          custom_setting = SiteSetting.send("images_guardian_#{m}")
          original_setting = SiteSetting.send("orig_#{m}")

          return original_setting if (!SiteSetting.images_guardian_enabled || custom_setting.blank?)

          custom_setting
        end

      end

    end
  end

}
