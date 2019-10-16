class Module
  unless respond_to?(:ruby2_keywords, true)
    private
    def ruby2_keywords(*)
      # nil
    end
  end
end
