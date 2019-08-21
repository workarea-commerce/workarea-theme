class MultipleThemesError < StandardError
  def initialize(msg = 'More than one theme installed.')
    super
  end
end
