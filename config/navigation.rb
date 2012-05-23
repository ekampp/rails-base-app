SimpleNavigation::Configuration.run do |navigation|
  navigation.items do |primary|
    primary.dom_id = 'main-navigation'

    primary.item :admin, t('application.menu.admin'), admin_users_path,
      class: "main-navigation-item", link: {
        class: "main-navigation-link",
        title: t("application.menu.admin_title")
      }, if: Proc.new{ logged_in? and current_user.role == "admin" }

    primary.item :account, t('application.menu.account'), my_account_path,
      class: "main-navigation-item", link: {
        class: "main-navigation-link",
        title: t("application.menu.account_title")
      }, if: Proc.new{ logged_in? }

    primary.item :logout, t('application.menu.logout'), logout_path,
      class: "main-navigation-item", link: {
        class: "main-navigation-link",
        title: t("application.menu.logout_title")
      }, if: Proc.new{ logged_in? }

    primary.item :login, t('application.menu.login'), login_path,
      class: "main-navigation-item", link: {
        class: "main-navigation-link",
        title: t("application.menu.login_title")
      }, unless: Proc.new{ logged_in? }
  end
end
