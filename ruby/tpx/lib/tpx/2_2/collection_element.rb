require 'tpx/2_2/data_model'

# { "name_id_s": "Albania", "iso_3_s": "alb", "iso_2_s": "al", "region_code_ui": 1, "continent_code_ui": 5, "continent_code_s": "eu", "country_code_ui": 8 }

module TPX_2_2

  # An element in a classification list.
  class CollectionElement < DataModel
    MANDATORY_ATTRIBUTES = [
      :name_id_s
    ]
  end
end
