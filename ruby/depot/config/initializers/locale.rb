# in config/initializers/locale.rb

# I18n.enforce_available_locales = false

# tell the I18n library where to find your translations
I18n.load_path += Dir[Rails.root.join('config', 'locales', '*.{rb,yml}')]
 
# set default locale to something other than :en
I18n.default_locale = :"zh-CN"