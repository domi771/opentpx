require 'tpx/2_1/data_model'

# { "name_id_s": "Albania", "iso_3_s": "alb", "iso_2_s": "al", "region_code_i": 1, "continent_code_i": 5, "continent_code_s": "eu", "country_code_i": 8 }

module TPX_2_1

  # An element in a classification list.
  class CollectionElement < DataModel
    MANDATORY_ATTRIBUTES = [
      :name_id_s
    ]
  end
end
