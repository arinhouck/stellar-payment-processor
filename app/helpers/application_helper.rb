module ApplicationHelper
  
  def nav_item(name, url, opts = {})
    html = <<-HTML
      <li class="navbar-item">
        #{link_to name, url, opts.merge({ class: 'navbar-link'})}
      </li>
    HTML
    raw html
  end
end
