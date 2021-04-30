module MyStore
    module Spree
        module ImageDecorator
            module ClassMethods
                def styles
                    {
                        large:   '600x600>',
                    }
                end
            end
            def self.prepended(base)
                base.inheritance_column = nil
                def styles
                    ::Spree::Image.styles.map do |_, size|
                        width, height = size.chop.split('x')                
                        {
                            url: "#{attachment.key}#{File.extname(attachment.filename.to_s)}",
                        #   url: polymorphic_path(attachment.variant(
                        #                           gravity: 'center',
                        #                           resize: size,
                        #                           extent: size,
                        #                           background: 'snow2',
                        #                           quality: 80
                        #                         ), only_path: true),
                          width: width,
                          height: height
                        }
                    end
                end
                base.singleton_class.prepend ClassMethods
            end
        end
    end
end
  
::Spree::Image.prepend ::MyStore::Spree::ImageDecorator
