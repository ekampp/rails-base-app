SimpleNavigation::Configuration.run do |navigation|
  navigation.items do |primary|
    primary.item :account, t('application.menu.account'), my_account_path, if: Proc.new{ logged_in? }
    primary.item :login, t('application.menu.login'), login_path, unless: Proc.new{ logged_in? }
  end
end
