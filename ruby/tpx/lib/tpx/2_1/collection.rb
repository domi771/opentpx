require 'tpx/2_1/homogeneous_list'
require 'tpx/2_1/collection_element'

# "collection_c_array": [
#     { "name_id_s": "Aruba", "iso_3_s": "abw", "iso_2_s": "aw", "region_code_i": 0, "continent_code_i": 6, "continent_code_s": "na", "country_code_i": 533 },
#     { "name_id_s": "Afghanistan", "iso_3_s": "afg", "iso_2_s": "af", "region_code_i": 1, "continent_code_i": 4, "continent_code_s": "as", "country_code_i": 4 },
#     { "name_id_s": "Angola", "iso_3_s": "ago", "iso_2_s": "ao", "region_code_i": 1, "continent_code_i": 1, "continent_code_s": "af", "country_code_i": 24 },
#     { "name_id_s": "Anguilla", "iso_3_s": "aia", "iso_2_s": "ai", "region_code_i": 0, "continent_code_i": 6, "continent_code_s": "na", "country_code_i": 660 },
#     { "name_id_s": "Aland Islands", "iso_3_s": "ala", "iso_2_s": "ax", "region_code_i": 0, "continent_code_i": 5, "continent_code_s": "eu", "country_code_i": 248 },
#     { "name_id_s": "Albania", "iso_3_s": "alb", "iso_2_s": "al", "region_code_i": 1, "continent_code_i": 5, "continent_code_s": "eu", "country_code_i": 8 }
# ]


module TPX_2_1

  # A named group of network elements, host elements or observables.
  class Collection < HomogeneousList
    homogeneous_list_of CollectionElement
    children_keyed_by :name_id_s
  end
end
