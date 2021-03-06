module TestXml
  module TestUnit
    module Assertions
      def self.assertions_for(name, options)
        define_method("assert_#{name}") do |subject, &block|
          pattern = block.call

          actual = Nokogiri::XML.parse(subject)
          expected = Nokogiri::XML.parse(pattern)

          full_message = options[:message_for_should].gsub(/\<pattern\>/, pattern).gsub(/\<subject\>/, subject)

          assert_block(full_message) do
            options[:matcher].call(actual, expected)
          end
        end

        define_method("assert_not_#{name}") do |subject, &block|
          pattern = block.call

          actual = Nokogiri::XML.parse(subject)
          expected = Nokogiri::XML.parse(pattern)

          full_message = options[:message_for_should_not].gsub(/\<pattern\>/, pattern).gsub(/\<subject\>/, subject)

          assert_block(full_message) do
            !options[:matcher].call(actual, expected)
          end
        end
      end

      assertions_for :match_xml,
                     :message_for_should     => "the xml:\n<subject>\nshould match xml:\n<pattern>",
                     :message_for_should_not => "the xml:\n<subject>\nshould not match xml:\n<pattern> but it does",
                     :matcher => Proc.new {|actual, expected| actual.match?(expected, true)}

      assertions_for :exactly_match_xml,
                     :message_for_should     => "the xml:\n<subject>\nshould exactly match xml:\n<pattern>",
                     :message_for_should_not => "the xml:\n<subject>\nshould not exactly match xml:\n<pattern> but it does",
                     :matcher => Proc.new {|actual, expected| actual.match?(expected, true) && expected.match?(actual, true) }

      assertions_for :match_xml_structure,
                     :message_for_should     => "the xml:\n<subject>\nshould match xml structure:\n<pattern>",
                     :message_for_should_not => "the xml:\n<subject>\nshould not match xml structure:\n<pattern> but it does",
                     :matcher => Proc.new {|actual, expected| actual.match?(expected)}

      assertions_for :exactly_match_xml_structure,
                     :message_for_should     => "the xml:\n<subject>\nshould exactly match xml structure:\n<pattern>",
                     :message_for_should_not => "the xml:\n<subject>\nshould not exactly match xml structure:\n<pattern> but it does",
                     :matcher => Proc.new {|actual, expected| actual.match?(expected) && expected.match?(actual) }
    end
  end
end
