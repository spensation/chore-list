<h1>Users</h1>
<ul>
  <% @users.each do |user| %>
    <li><%= user.username %> - - <%= user.id %><li>
  <% end %>
</ul>
