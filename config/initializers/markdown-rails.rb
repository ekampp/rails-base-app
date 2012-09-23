MarkdownRails.configure do |config|
  markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML,
    fenced_code_blocks: true,
    autolink: true,
    no_intraemphasis: true,
    gh_blockcode: true,
    filter_html: true,
    hard_wrap: true
  )
  config.render do |markdown_source|
    markdown.render(markdown_source)
  end
end
