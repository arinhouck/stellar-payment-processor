module ApplicationHelper
  
  def nav_item(name, url, opts = { class: 'navbar-link' })
    html = <<-HTML
      <li class="navbar-item">
        #{link_to name, url, opts}
      </li>
    HTML
    raw html
  end
end
