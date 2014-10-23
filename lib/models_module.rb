module ModelsModule
  def update_errors(record)
    if record.errors
      record.attributes.each do | attr |
        attr_as_symbol = attr[0].to_sym
        if record.errors.added? attr_as_symbol, :blank
          record.errors.set(attr_as_symbol, ["can't be blank."])
        end
      end
    end
  end
end
