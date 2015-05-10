module BeforeRender
 extend ActiveSupport::Concern

 included do
     alias_method_chain :render, :before_render_action
     define_callbacks :render
 end

 def render_with_before_render_action(*options, &block)
     run_callbacks :render do
         render_without_before_render_action *options, &block
     end
 end

 module ClassMethods
     def append_before_render_action(*names, &block)
         _insert_callbacks(names, block) do |name, options|
             set_callback :render, :before, name, options
         end
     end

     def prepend_before_render_action(*names, &block)
         _insert_callbacks(names, block) do |name, options|
             set_callback :render, :before, name, options.merge(:prepend => true)
         end
     end

     def skip_before_render_action(*names, &block)
         _insert_callbacks(names, block) do |name, options|
             skip_callback :render, :before, name, options
         end
     end

     alias_method :before_render, :append_before_render_action
     alias_method :prepend_before_render, :prepend_before_render_action
     alias_method :skip_before_render, :skip_before_render_action
 end
end
