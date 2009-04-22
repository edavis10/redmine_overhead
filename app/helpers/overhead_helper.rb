module OverheadHelper
  def select_values_for_field(field)
    return [] if field.nil?

    if field.field_format == 'list'
      returning [] do |r|
        field.possible_values.each do |item|
          if item == 'Nil'
            r << [l(:label_none), item] # Nil should use the none label
          else
            r << [item, item]
          end
        end
        r
      end
    elsif field.field_format == 'bool'
      return [['true','true'],['false','false']]
    end
  end
end
