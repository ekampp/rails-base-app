#
# TODO: Refactor the `info_`, `alert_` og `notice_` methods to some kind of
#       single method. <emil@kampp.me>
#
module ApplicationHelper

  #
  # Constructs an info box
  # This takes a single `string` argument.
  #
  # Examples:
  #   * info_box 'hello'
  #
  def info_box text
    content_tag :span, class: "info" do
      content_tag(:span, "2", class: "info-icon") +
      content_tag(:span, text, class: "info-text")
    end
  end

  #
  # Constructs an alert box
  # This takes a single `string` argument.
  #
  # Examples:
  #   * alert_box 'hello'
  #
  def alert_box text
    content_tag :span, class: "alert" do
      content_tag(:span, "!", class: "alert-icon") +
      content_tag(:span, text, class: "alert-text")
    end
  end

  #
  # Constructs an notice box.
  # This takes a single `string` argument.
  #
  # Examples:
  #   * notice_box 'hello'
  #
  def notice_box text
    content_tag :span, class: "notice" do
      content_tag(:span, "J", class: "notice-icon") +
      content_tag(:span, text, class: "notice-text")
    end
  end

end
