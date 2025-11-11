class ParamHandler < YARD::Handlers::Ruby::Base
  handles method_call(:param)
  namespace_only

  process do
    definition = statement[1][0]
    name = definition.jump(:tstring_content, :ident).source
    name_base = name[...-1]
    definition.docstring =  <<~xx
      @note This is the _param_ - +#{name}+, +##{name_base}=+ and +##{name_base}+ are defined. Check *Flags and Params* for more info.
      #{statement.docstring}
    xx
    parse_block(definition, namespace: namespace)
  end
end

class FlagHandler < YARD::Handlers::Ruby::Base
  handles method_call(:flag)
  namespace_only

  process do
    definition = statement[1][0]
    name = definition.jump(:tstring_content, :ident).source
    name_base = name[...-1]
    arg_name = definition.jump(:params).jump(:tstring_content, :ident).source
    definition.docstring =  <<~xx
      @note This is the _flag_ - +#{name}+, +##{name_base}=+, +##{name_base}+ and +##{name_base}?+ are defined. Check *Flags and Params* for more info.
      @param #{arg_name} [true, false, :not] Set if +true+, unset if +false+, negate if +:not+.
      #{statement.docstring}
    xx
    parse_block(definition, namespace: namespace)
  end
end