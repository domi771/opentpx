require 'tpx'
require 'date'

class EmergingThreatsToTPX_2_2

  def initialize
    @list_name = 'EmergingDshieldRules'
    @file_name = 'EmergingDshieldRules.txt'
    @file_path = 'raw_data/EmergingDshieldRules.txt'
  end

  def process_and_write_output_file
    exchange = transform(@file_path)
    exchange.to_tpx_file('data/EmergingDshieldRules.json', { :indent => 2 })
  end

  def load_and_validate_tpx_file
    TPX_2_2::Exchange.import_file('data/EmergingDshieldRules.json')
  end

  def transform(input_file_path)
    exchange_args = {
      provider_s: 'rules.emergingthreats.net',
      source_observable_s: @list_name,
      source_description_s: 'Rules to detect dshield attackers by 24/7. Emerging Threats is a world-leading provider of commercial and open source threat intelligence.',
      distribution_time_t: Time.now.getutc.to_i,
      last_updated_t: Time.now.getutc.to_i,
      list_name_s: @list_name,
      observable_dictionary_c_array:  [
        {
          "observable_id_s" => "Compromised",
          "criticality_i" => 20,
          "description_s" => "This network node is a malicious host.",
          "classification_c_array" => [
            {
              "classification_id_s" => "Malicious Host",
              "score_i" => 20
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
    return if row.match(/^\s*#/)

    elements = []
    protocol = ""
    ip_list = ""
    threat_observable_msg = ""

    fields = row.split(';')
    net_data = fields.shift
    net_data.match(/alert\s+(\w+)\s+\[(.+)\]\s+.+\(\w+\:\"(.+)\"/) do |m|
      protocol = m[1]
      ip_list = m[2]
      threat_observable_msg = m[3]
    end

    ip_list = ip_list.split(',')

    ip_list.each do |cidr|
      subject = cidr

      threat_observable = { 'Compromised' => {}}
      threat_observable['Compromised']['description_s_array'] = [threat_observable_msg] if threat_observable_msg.present?
      threat_observable['Compromised']['protocol_s_array'] = [protocol] if protocol.present?
      threat_observable['Compromised']['occurred_at_t'] = Time.now.getutc.to_i

      element = TPX_2_2::ElementObservable.new(
        {
          subject_cidrv4_s: subject,
          threat_observable_c_map: threat_observable
        }
      )

      elements << element
    end

    return elements
  end

end
