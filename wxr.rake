namespace :wxr do

task :export => :environment do
  # To avoid installing uuidtools in old ruby/gems environment
  # I use UUIDGEN path to a tool generating UUIDs. If it's
  # present, just use that tool and don't load 'uuidtools'
  require 'uuidtools' unless ENV['UUIDGEN']
  if ENV['MEPHISTO_SITE']
    site = Site.find_by_host(ENV['MEPHISTO_SITE'])
  else
    site = Site.find(:first)
  end

  tags = []
  sections = []

  xml = Builder::XmlMarkup.new(:target => STDOUT, :indent => 2)

  xml.instruct! :xml, :version=>"1.0", :encoding=>"UTF-8"
  xml.rss 'version' => "2.0",
          'xmlns:content' => "http://purl.org/rss/1.0/modules/content/",
          'xmlns:wfw' => "http://wellformedweb.org/CommentAPI/",
          'xmlns:dc' => "http://purl.org/dc/elements/1.1/",
          'xmlns:wp' => "http://wordpress.org/export/1.0/" do
    xml.channel do
      xml.title site.title
      xml.link "http://#{site.host}"
      xml.language "en-us"
      xml.wp :wxr_version, "1.0"
      xml.ttl "40"
      xml.description site.subtitle

      site.articles.each do |a|
        a.published_at ||= a.created_at
          xml.item do
            xml.title a.title

            # I don't know why, but WordPress cuts my article at this character.
            # It's frustating... but #gsub to the rescue!
            xml.content(:encoded) { |x| x << a.body_html.gsub("à", "&#224;") }
            xml.pubDate a.published_at.rfc2822

            # Here is the magic tool
            if ENV['UUIDGEN']
              xml.guid "urn:uuid:#{%x(#{ENV['UUIDGEN']}).chomp}", "isPermaLink" => "false"
            else
              xml.guid "urn:uuid:#{UUIDTools::UUID.random_create}", "isPermaLink" => "false"
            end
            author = a.user.login
            xml.author author
            xml.dc :creator, author

            # Treat tags accordingly.
            a.tags.each do |tag|

              # WordPress also doesn't seem to like HTTP entities like &amp;
              n = tag.name.gsub("&amp;", "&")
              tags << n unless tags.include?(n)
                xml.category "domain"=>"post_tag", "nicename"=>n do
               xml.cdata! n
              end
            end

            # Translate Mephisto Sections into WordPress Categories.
            a.sections.each do |section|
              n = section.name.gsub("&amp;", "&")
              sections << n unless sections.include?(n)
                      xml.category "domain"=>"category", "nicename"=>n do
                xml.cdata! n
              end
            end

            xml.wp :post_id, a.id
            xml.wp :post_date, a.published_at.strftime("%Y-%m-%d %H:%M:%S")

            # I like to leave articles open to commenting indefinitely.
            xml.wp :comment_status, 'open'
            xml.wp :ping_status, 'closed'
            xml.wp :post_name, a.permalink
            xml.wp :status, 'publish'
            xml.wp :post_parent, '0'
            xml.wp :post_type, 'post'
            for comment in a.comments
              xml.wp(:comment) do
                xml.wp :comment_id, comment.id
                xml.wp :comment_author, comment.author
                xml.wp :comment_author_email, comment.author_email
                xml.wp :comment_author_url, comment.author_url
                xml.wp :comment_author_IP, comment.author_ip

                # I don't know if I had a bug in my Mephisto or if every Mephisto has
                # this bug: comment.published_at is the same as article.published_at...
                # It seemed that every comment was made at the same time!
                xml.wp :comment_date, comment.created_at.strftime("%Y-%m-%d %H:%M:%S")
                xml.wp(:comment_content) { |x| x << comment.body_html }
                xml.wp :comment_approved, '1'
                xml.wp :comment_parent, '0'
              end
            end
         end
      end

      # WordPress WXR also has a special section with the declaration
      # of all categories and tags. I think every tag or category have to
      # have a unique integer id, so I just use an incrementing counter,
      # starting with 100
      next_id = 100
      sections.each do |section|
        xml.wp :category do
          xml.wp :term_id, next_id
          xml.wp :category_nicename, section
          xml.wp :cat_name do
            xml.cdata! section
          end
          xml.wp :category_description do
            xml.cdata! section
          end
          next_id += 1
        end
      end

      tags.each do |tag|
        xml.wp :tag do
          xml.wp :term_id, next_id
          xml.wp :tag_slug, tag
          xml.wp :tag_name do
            xml.cdata! tag
          end
          next_id += 1
        end
      end
    end
  end
end

end
