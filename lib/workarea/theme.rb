# frozen_string_literal: true

require 'workarea'
require 'workarea/storefront'
require 'workarea/admin'

require 'workarea/theme/engine'
require 'workarea/theme/version'
require 'workarea/theme/errors'

module Workarea
  module Theme
    extend ActiveSupport::Concern
    mattr_accessor :installed

    included do
      extend Workarea::MountPoint

      mod = to_s.gsub('::Engine', '').constantize

      def mod.slug
        to_s.gsub('Workarea::', '').underscore
      end

      def mod.homebase_name
        to_s.gsub('Workarea::', '').gsub('::', ' ').titleize
      end

      def mod.root
        const_get(:Engine).root
      end

      if Workarea::Theme.installed.present?
        raise MultipleThemesError
      else
        Workarea::Theme.installed = mod
      end
    end
  end
end
