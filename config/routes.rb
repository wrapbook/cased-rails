Cased::Rails::Engine.routes.draw do
  get '/guard/sessions/:guard_session_id' => 'cased/guard/sessions#show', as: :guard_session
  post '/guard/sessions/:guard_session_id/cancel' => 'cased/guard/sessions#cancel', as: :cancel_guard_session
end
