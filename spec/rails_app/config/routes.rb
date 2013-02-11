RailsApp::Application.routes.draw do
  responses = {
    200 => lambda { |env| [200, {}, ['welcome']] },
    404 => lambda { |env| [404, {}, ['not found']] }
  }

  github_authenticate    { get '/protected'           => responses[200] }
  github_authenticated   { get '/conditional'         => responses[200] }
  github_unauthenticated { get '/conditional_inverse' => responses[200] }

  github_authenticate(:admin)    { get '/admin/protected'           => responses[200] }
  github_authenticated(:admin)   { get '/admin/conditional'         => responses[200] }
  github_unauthenticated(:admin) { get '/admin/conditional_inverse' => responses[200] }

  github_authenticate(:team => 123)  { get '/team/protected'   => responses[200] }
  github_authenticated(:team => 123) { get '/team/conditional' => responses[200] }

  github_authenticate(:team => :marketing)  { get '/team_alias/protected'   => responses[200] }
  github_authenticated(:team => :marketing) { get '/team_alias/conditional' => responses[200] }

  github_authenticate(:org => :foobar_inc)  { get '/org/protected'   => responses[200] }
  github_authenticated(:org => :foobar_inc) { get '/org/conditional' => responses[200] }

  github_authenticate(:organization => 'some_org')  { get '/organization/protected'   => responses[200] }
  github_authenticated(:organization => 'some_org') { get '/organization/conditional' => responses[200] }

  match '*all' => responses[404]
end
