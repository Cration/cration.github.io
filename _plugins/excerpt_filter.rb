module Jekyll
    module ExcerptFilter
        def extract_excerpt(input)
            input.split('<!--excerpt-->')[1]
        end
    end
end

Liquid::Template.register_filter(Jekyll::ExcerptFilter)
