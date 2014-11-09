Deface::Override.new(:virtual_path => "spree/shared/_login",
                     :name => "replace_sessions_email_field",
                     :replace => "erb[loud]:contains('f.email_field')",
                     :text => "<%= f.email_field :login, :class => 'title', :tabindex => 1, autofocus: true %>",
                     :disabled => false)
                   #  :original => 'eb3fa668cd98b6a1c75c36420ef1b238a1fc55ac')