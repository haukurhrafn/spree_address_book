module Spree::AddressBookHelper
  def address_field(form, method, id_prefix = "b", &handler)
    # stay in line with the default spree method of p#id naming
    # this ensures that JS state selection, and other future checkout.js things, will keep working
    id_prefix = id_prefix[0] if id_prefix.length > 1

    content_tag :p, :id => [id_prefix, method].join(''), :class => "field" do
      if handler
        handler.call
      else
        is_required = Spree::Address.required_fields.include?(method)
        separator = is_required ? '<span class="req">*</span><br />' : '<br />'
        form.label(method) + separator.html_safe +
        form.text_field(method, :class => is_required ? 'required' : nil)
      end
    end
  end

  def address_state(form, country)
    country ||= Spree::Country.find(Spree::Config[:default_country_id])
    have_states = !country.states.empty?
    state_elements = [
      form.collection_select(:state_id, country.states.order(:name),
                            :id, :name,
                            {:include_blank => true},
                            {:class => have_states ? "required" : "hidden",
                            :disabled => !have_states}) +
      form.text_field(:state_name,
                      :class => !have_states ? "required" : "hidden",
                      :disabled => have_states)
      ].join.gsub('"', "'").gsub("\n", "")

    form.label(:state, t(:state)) + '<span class="req">*</span><br />'.html_safe +
      content_tag(:noscript, form.text_field(:state_name, :class => 'required')) +
      javascript_tag("document.write(\"#{state_elements.html_safe}\");")
  end
end