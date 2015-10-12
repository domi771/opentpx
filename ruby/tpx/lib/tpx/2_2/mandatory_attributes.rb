module TPX_2_2
  module MandatoryAttributes
    MANDATORY_ATTRIBUTES = [] # override in consumer
    MUST_HAVE_ONE_OF_ATTRIBUTES = []
    MUST_HAVE_ONE_AND_ONLY_ONE_OF_ATTRIBUTES = []

    # Perform all validations.
    def validate!
      validate_mandatory_attributes!

      validate_must_have_one_of_attributes!

      validate_must_have_one_and_only_one_of_attributes!
    end # def validate!

    # Perform validation of all mandatory attributes.
    def validate_mandatory_attributes!
      self.class::MANDATORY_ATTRIBUTES.each do |attrib|
        if self[attrib].nil?
          raise ValidationError, "The mandatory attribute `#{attrib}` is missing from the supplied input_hash paramater to #{self.class}."
        end
      end
    end

    # Perform validation of all sets of attributes of which at least one are required.
    def validate_must_have_one_of_attributes!
      self.class::MUST_HAVE_ONE_OF_ATTRIBUTES.each do |attrib_set|
        unless attrib_set.is_a? Array
          raise AttributeDefinitionError, "Elements of #{self.class}::MUST_HAVE_ONE_OF_ATTRIBUTES must be of type Array."
        end

        has_one_of_mandatory_set = false
        attrib_set.each do |attrib|
          if self.has_key?(attrib) && !self[attrib].nil?
            has_one_of_mandatory_set = true
            break
          end
        end

        unless has_one_of_mandatory_set
          raise ValidationError, "A member of the mandatory attribute set `#{attrib_set}` is missing from the supplied input_hash paramater to #{self.class}."
        end
      end
    end

    # Perform validation of all sets of attributes of which only one is required.
    def validate_must_have_one_and_only_one_of_attributes!
      self.class::MUST_HAVE_ONE_AND_ONLY_ONE_OF_ATTRIBUTES.each do |attrib_set|
        unless attrib_set.is_a? Array
          raise AttributeDefinitionError, "Elements of #{self.class}::MUST_HAVE_ONE_AND_ONLY_ONE_OF_ATTRIBUTES must be of type Array."
        end

        count_of_mandatory_set = 0
        attrib_set.each do |attrib|
          if self.has_key?(attrib)
            count_of_mandatory_set += 1
          end
        end

        if count_of_mandatory_set == 0
          raise ValidationError, "A member of the mandatory attribute set `#{attrib_set}` is missing from the supplied input_hash paramater to #{self.class}."
        elsif count_of_mandatory_set > 1
          raise ValidationError, "More than one member of the exclusive and mandatory attribute set `#{attrib_set}` was provided to #{self.class}."
        end
      end
    end

  end
end
