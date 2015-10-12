def path_to_string(path):
  """function for converting a deque into a string"""
  string = ''
  for value in path:
    # if the current value is an array index
    if type(value) is int:
      string += ('[' + str(value) + ']')
    # if the current value is a string at the beginning of the path
    elif string == '':
      string += str(value)
    # if the current value is a string in the middle of the path
    else:
      string += ('::' + str(value))
    
  return string

def errors_to_string(errors):
  """function for converting an array of errors into a string of unique errors"""
  full_errors = ['\t' + path_to_string(e.absolute_path) + ': ' + e.message for e in errors]
  full_errors = list(set(full_errors))
  string = '\n'.join(full_errors)
  return string
  
