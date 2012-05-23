module ApplicationHelper

  #
  # This will construct an info box, of the given `type` (defaults to info)
  # and with the given `text`.
  #
  # Additionally you can supply a third argument, which indicates the `letter`
  # for the icon of the box. This will overwrite the icon determined by the
  # `type` of the box.
  #
  #
  def info_box text, options = {}
    Rails.logger.debug("Options for info box: #{options.inspect}")

    allow_remove = options[:allow_remove]
    type = options[:type] || :info

    case type.to_sym
    when :alert
      letter = "!"
    when :notice
      letter = "J"
    else
      letter = "2"
    end

    content_tag :span, class: "info-box #{type.to_s}" do
      content_tag(:span, letter, class: "info-icon") +
      content_tag(:span, text, class: "info-text") +
      (allow_remove ? content_tag(:span, "x", class: "info-remove", data: { remove_box: true }, title: t('application.info_box.remove_box')) : "")
    end
  end
end
