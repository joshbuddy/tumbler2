require 'git'
module Tumbler
  module Generators
    module Actions

      def self.included(base)
        base.extend ClassMethods
      end

      # Performs the necessary generator for a given component choice
      # execute_component_setup(:mock, 'rr')
      def execute_component_setup(component, choice)
        return true && say("Skipping generator for #{component} component...", :yellow) if choice.to_s == 'none'
        say "Applying '#{choice}' (#{component})...", :yellow
        apply_component_for(choice, component)
        send("setup_#{component}") if respond_to?("setup_#{component}")
      end

      # Returns the related module for a given component and option
      # generator_module_for('rr', :mock)
      def apply_component_for(choice, component)
        # I need to override Thor#apply because for unknow reason :verobse => false break tasks.
        path = File.expand_path(File.dirname(__FILE__) + "/components/#{component}/#{choice}.rb")
        say_status :apply, "#{component}/#{choice}"
        shell.padding += 1
        instance_eval(open(path).read)
        shell.padding -= 1
      end

      # Prompts the user if necessary until a valid choice is returned for the component
      # resolve_valid_choice(:mock) => 'rr'
      def resolve_valid_choice(component)
        available_string = self.class.available_choices_for(component).join(", ")
        choice = options[component]
        until valid_choice?(component, choice)
          say("Option for --#{component} '#{choice}' is not available.", :red)
          choice = ask("Please enter a valid option for #{component} (#{available_string}):")
        end
        choice
      end

      # Returns true if the option passed is a valid choice for component
      # valid_option?(:mock, 'rr')
      def valid_choice?(component, choice)
        choice && self.class.available_choices_for(component).include?(choice.to_sym)
      end

      # Run the bundler
      def run_bundler
        say "Bundling application dependencies using bundler...", :yellow
        in_root { run 'bundle install' }
      end

      # Returns the root for this thor class (also aliased as destination root).
      def destination_root(*paths)
        File.join(@destination_stack.last, paths)
      end

      def generate_path(*path)
        File.join(options[:root],name,path)
      end

      def initial_commit
        say "Performing initial commit...", :yellow
        git = ::Git.init(generate_path)
        git.add('.')
        git.commit('initial commit')
        git.add_tag(@version) unless options[:version] =~ /none/
      end

      def constant_name
        result = name.split('_').map{|p| p.capitalize}.join
        result = result.split('-').map{|q| q.capitalize}.join('::') if result =~ /-/
        result
      end

      def generate_version
        @version = options[:version] || '0.0.0'
        template('templates/version.rb.erb',generate_path("lib/#{name}/version.rb"))
      end

      def generate_changelog
        @changelog = options[:changelog] || Manager::Changelog::DEFAULT_FILE
        create_file generate_path(@changelog)
      end

      def generate_dependencies
        dependencies, development_dependencies = [], [::Gem::Dependency.new('tumbler')]
        options[:dependencies].split(',').each { |dep| dependencies << ::Gem::Dependency.new(*Array(dep)) } if options[:dependencies]
        options[:development_dependencies].split(',').each { |dep| development_dependencies << ::Gem::Dependency.new(*Array(dep)) } if options[:development_dependencies]
        [dependencies, development_dependencies]
      end

      def generate_gemspec
        template('templates/generic.gemspec.erb',generate_path("#{name}.gemspec"))
      end

      def generate_gemfile
        @dependencies, @development_dependencies = generate_dependencies
        template('templates/Gemfile.erb',generate_path('Gemfile'))
      end

      module ClassMethods
        # Defines a class option to allow a component to be chosen and add to component type list
        # Also builds the available_choices hash of which component choices are supported
        # component_option :test, "Testing framework", :aliases => '-t', :choices => [:bacon, :shoulda]
        def component_option(name, caption, options = {})
          (@component_types   ||= []) << name # TODO use ordered hash and combine with choices below
          (@available_choices ||= {})[name] = options[:choices]
          description = "The #{caption} component (#{options[:choices].join(', ')}, none)"
          class_option name, :default => options[:default] || options[:choices].first, :aliases => options[:aliases], :desc => description
        end

        # Returns the compiled list of component types which can be specified
        def component_types; @component_types; end
        # Returns the list of available choices for the given component (including none)
        def available_choices_for(component); @available_choices[component] + [:none]; end

      end

    end
  end
end
