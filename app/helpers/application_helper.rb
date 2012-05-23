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
  def info_box text, type = :info, letter = nil
    unless letter.is_a?(String)
      case type.to_sym
      when :alert
        letter = "!"
      when :notice
        letter = "J"
      else
        letter = "2"
      end
    end

    content_tag :span, class: "info-box" do
      content_tag(:span, letter, class: "info-icon #{type.to_s}") +
      content_tag(:span, text, class: "info-text")
    end
  end
end
