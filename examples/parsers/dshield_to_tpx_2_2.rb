require 'tpx'
require 'date'

class DshieldToTPX_2_2

  def initialize
    @list_name = 'DshieldTop100IpReport'
    @file_name = 'DshieldTop100IpReport.txt'
    @file_path = 'raw_data/DshieldTop100IpReport.txt'
  end

  def process_and_write_output_file
    exchange = transform(@file_path)
    exchange.to_tpx_file('data/DshieldBlocklistTPX.json', { :indent => 2 })
  end

  def load_and_validate_tpx_file
    TPX_2_2::Exchange.import_file("data/DshieldBlocklistTPX.json")
  end

  def transform(input_file_path)
    exchange_args = {
      provider_s: 'feeds.dshield.org',
      source_observable_s: @list_name,
      source_description_s: 'Dshield Top 100 Ip Report. ISC provides a free analysis and warning service to thousands of Internet users and organizations, and is actively working with Internet Service Providers to fight back against the most malicious attackers.',
      distribution_time_t: Time.now.getutc.to_i,
      last_updated_t: Time.now.getutc.to_i,
      list_name_s: @list_name,
      observable_dictionary_c_array: [
        {
          "observable_id_s" => "DShield_DROP",
          "criticality_i" => 20,
          "description_s" => "This network node is a malicious host.",
          "classification_c_array" => [
            {
              "classification_id_s"=> "Malicious Host",
              "score_i"=> 20
            }
          ]
        }
      ]
    }

    @exchange = TPX_2_2::Exchange.new(exchange_args)
    iterate_over_file_records_and_transform( input_file_path )

    return @exchange
  end

  def iterate_over_file_records_and_transform(input_file)
    line_count = 0
    input_file.encode!('utf-8', :invalid => :replace)
    File.foreach(input_file) do |row|
      row.gsub!(/\u0000/, '')
      line_count += 1
      row_identifier = "#{@list_name}:#{@file_name}:#{line_count.to_s}"
      element = transform_element(row, row_identifier)
      @exchange << element unless element.nil?
    end
  end

  def transform_element(row, row_id)
    element = nil
    subject = row.chomp!
    meta_hash = {}

    subject.match(/(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})\s?+(.+)?/) do |s|
      meta_hash['destination_fqdn_s'] = s[2] unless s[2].nil?
      meta_hash['occurred_at_t'] = Time.now.getutc.to_i
      element = TPX_2_2::ElementObservable.new(
        {
          subject_ipv4_s: s[1],
          threat_observable_c_map: {
            'DShield_DROP' => meta_hash
          }
        }
      )
    end

    return element
  end
end
