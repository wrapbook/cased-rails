module CasedHelper
  def guarded_parameters(form)
    form_params = params.except(:authenticity_token, :controller, :action)

    safe_join render_guarded_parameters(form, form_params.to_unsafe_h)
  end

  def render_guarded_parameters(form, form_params, prefix = nil)
    form_params.collect do |key, value|
      case value
      when Hash
        render_guarded_parameters(form, value, key)
      else
        name = prefix ? "#{prefix}[#{key}]" : key
        hidden_field_tag(name, value)
      end
    end
  end
end
