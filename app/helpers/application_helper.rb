module ApplicationHelper
  # Swaps only the leading /:locale segment of the current path so the locale
  # switcher keeps working as more pages are added beyond the home page.
  def switch_locale_path(locale)
    request.path.sub(%r{\A/[^/]+}, "/#{locale}")
  end

  def markdown(text)
    Redcarpet::Markdown.new(Redcarpet::Render::HTML).render(text.to_s).html_safe
  end
end
