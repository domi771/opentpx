require 'tpx/2_1/data_model'
require 'tpx/2_1/threat_observable'
require 'tpx/2_1/observable'

module TPX_2_1

  # A set of threat observable associations to one or more subjects
  # (i.e. elements) including network, host or user subjects.
  class ElementObservable < DataModel

    MANDATORY_ATTRIBUTES = [:threat_observable_c_map]

    MUST_HAVE_ONE_AND_ONLY_ONE_OF_ATTRIBUTES = [
      [
        :subject_ipv4_s,
        :subject_ipv4_i,
        :subject_ipv6_s,
        :subject_ipv6_i,
        :subject_fqdn_s,
        :subject_cidrv4_s,
        :subject_cidrv6_s,
        :subject_asn_s,
        :subject_asn_i,
        :subject_md5_h,
        :subject_sha1_h,
        :subject_sha256_h,
        :subject_sha512_h,
        :subject_registrykey_s,
        :subject_filename_s,
        :subject_filepath_s,
        :subject_mutex_s,
        :subject_actor_s,
        :subject_email_s
      ]
    ]

    SUBJECT_ATTRIBUTES = MUST_HAVE_ONE_AND_ONLY_ONE_OF_ATTRIBUTES.first

  end # class ElementObservable
end # module TPX_2_1
