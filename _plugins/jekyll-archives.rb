require "jekyll"

module Jekyll
  module Archives
    # Internal requires
    autoload :Archive, "jekyll-archives/archive"
    autoload :VERSION, "jekyll-archives/version"

    class Archives < Jekyll::Generator
      safe true

      DEFAULTS = {
        "layout"     => "archive",
        "enabled"    => [],
        "permalinks" => {
          "year"     => "/:year/",
          "month"    => "/:year/:month/",
          "day"      => "/:year/:month/:day/",
          "tag"      => "/tag/:name/",
          "category" => "/category/:name/"
        }
      }.freeze

      def initialize(config = nil)
        @config = if config["jekyll-archives"].nil?
                    DEFAULTS
                  else
                    Utils.deep_merge_hashes(DEFAULTS, config["jekyll-archives"])
                  end
      end

      def generate(site)
        @site = site
        @posts = site.posts
        @archives = []

        @site.config["jekyll-archives"] = @config

        @allTags = tags
        @allCats = categories

        read
        @site.pages.concat(@archives)

        @site.config["archives"] = @archives
      end

      # Read archive data from posts
      def read
        read_bliki_tags
        read_bliki_categories

        read_tags
        read_categories
        read_dates
      end

      def read_bliki_tags
        @site.collections["bliki"].docs.each do |doc|
          doc.data["tags"].each do |tag|
            if @allTags.key?(tag)
              @allTags[tag] << doc
            else
              @allTags[tag] = [] << doc
            end
          end
        end
      end

      def read_bliki_categories
        @site.collections["bliki"].docs.each do |doc|
          doc.data["categories"].each do |category|
            if @allCats.key?(category)
              @allCats[category] << doc
            else
              @allCats[category] = [] << doc
            end
          end
        end
      end

      def read_tags
        if enabled? "tags"
          @allTags.each do |title, posts|
            @archives << Archive.new(@site, title, "tag", posts)
          end
        end
      end

      def read_categories
        if enabled? "categories"
          @allCats.each do |title, posts|
            @archives << Archive.new(@site, title, "category", posts)
          end
        end
      end

      def read_dates
        years.each do |year, posts|
          @archives << Archive.new(@site, { :year => year }, "year", posts) if enabled? "year"
          months(posts).each do |month, posts|
            @archives << Archive.new(@site, { :year => year, :month => month }, "month", posts) if enabled? "month"
            days(posts).each do |day, posts|
              @archives << Archive.new(@site, { :year => year, :month => month, :day => day }, "day", posts) if enabled? "day"
            end
          end
        end
      end

      # Checks if archive type is enabled in config
      def enabled?(archive)
        @config["enabled"] == true || @config["enabled"] == "all" || if @config["enabled"].is_a? Array
                                                                       @config["enabled"].include? archive
        end
      end

      def tags
        @site.post_attr_hash("tags")
      end

      def categories
        @site.post_attr_hash("categories")
      end

      # Custom `post_attr_hash` method for years
      def years
        hash = Hash.new { |h, key| h[key] = [] }

        # In Jekyll 3, Collection#each should be called on the #docs array directly.
        if Jekyll::VERSION >= "3.0.0"
          @posts.docs.each { |p| hash[p.date.strftime("%Y")] << p }
        else
          @posts.each { |p| hash[p.date.strftime("%Y")] << p }
        end
        hash.values.each { |posts| posts.sort!.reverse! }
        hash
      end

      def months(year_posts)
        hash = Hash.new { |h, key| h[key] = [] }
        year_posts.each { |p| hash[p.date.strftime("%m")] << p }
        hash.values.each { |posts| posts.sort!.reverse! }
        hash
      end

      def days(month_posts)
        hash = Hash.new { |h, key| h[key] = [] }
        month_posts.each { |p| hash[p.date.strftime("%d")] << p }
        hash.values.each { |posts| posts.sort!.reverse! }
        hash
      end
    end
  end
end
