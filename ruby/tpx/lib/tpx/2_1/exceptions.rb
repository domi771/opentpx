module TPX_2_1
  # Warning thrown when validation pass but there's some information worth passing to the caller
  class ValidationWarning < RuntimeError; end

  # Error thrown when an instantialized object invalid.
  class ValidationError < RuntimeError; end

  # Error thrown when a duplicate element is inserted into a list.
  class DuplicateElementInsertError < RuntimeError; end

  # Error thrown when a required attribute is not found.
  class AttributeDefinitionError < StandardError; end
end
