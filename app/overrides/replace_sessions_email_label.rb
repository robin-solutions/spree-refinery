Deface::Override.new(:virtual_path => "spree/shared/_login",
                     :name => "replace_sessions_email_label",
                     :replace => "erb[loud]:contains('Spree.t(:email)')",
                     :text => "<%= f.label :login, Spree.t(:email) %>",
                     :disabled => false)
                    # :original => 'eb3fa668cd98b6a1c75c36420ef1b238a1fc55ac')