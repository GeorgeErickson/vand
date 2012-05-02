$ = window.jQuery
class ValidationFunctions
  constructor: (@$form) ->
  required: ($field, options) ->
    if not $field.val()
      @$form.trigger 'vand:required',
        field: $field
        valid: false
  
  email: ($field, options) ->
    return true
  
  equal: ($field, options) ->
    #make sure the values in both fields are equal
    this_val = $field.val()
    that_val = @$form.find("[name=#{options.field}]").val()
    if this_val isnt that_val
      @$form.trigger 'vand:equal',
        field: $field
        valid: false
        
  password: ($field, options) ->
    #check if password is long enough
    password_length = $field.val().length
    required_length = parseInt options.length
    if password_length < required_length 
      @$form.trigger 'vand:password:length',
        field: $field
        valid: false
        password_length: password_length
        required_length: required_length 
        

class Validate
  constructor: (@form, @options) ->
    @$form = $ @form
    @funcs = new ValidationFunctions(@$form)
    #bind events to inputs
    for field in @$form.find('[data-vand-validation]')
      @attach field

  attach: (field) ->
    $field = $ field
    data = $field.data()
    
    triggers = data.vandTrigger.split(' ')
    for trigger in triggers
      [el_name, ev] = trigger.split(':')
      
      switch el_name
        when "form" then $el = @$form
        when "this" then $el = $field
        else $el = @$form.find("[name=#{el_name}],##{el_name},.#{el_nam}")
      
      $el.bind ev, =>
        @validate field
  
  validate: (field) ->
    $field = $ field
    data = $field.data()
    validations = data.vandValidation.split(' ')
    
    for validation_string in validations
      [validation_func, validation_args] =  validation_string.split('?')
      
      #validation_args are formatted like a url string, this turns them into an object
      validation_options = {}
      if validation_args
        for arg in validation_args.split('&')
          [key, value] = arg.split('=')
          validation_options[key] = value
      
      @funcs[validation_func] $field, validation_options
    
    
  


#jquery plugin info
$.fn.validate = (options) ->
  this.each ->
    $this = $ this
    $valid = $this.data 'validate'
    if not $valid
      $valid = new Validate(this, options)
      $this.data 'validate', $valid
    else
      $valid.validate(options)
      
      
      

$ ->
  $('#form01').validate().on('vand:equal', (ev, data)->
    data.field.parents('.control-group').addClass('error')
  ).on('vand:required', (ev, data)->
    data.field.parents('.control-group').addClass('error')
  ).on('vand:password:length', (ev, data)->
    data.field.parents('.control-group').addClass('error')
  )
