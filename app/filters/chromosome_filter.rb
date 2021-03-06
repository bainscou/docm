class ChromosomeFilter
  include Filter

  def self.filter(relation, values)
    relation.where('locations.chromosome' => values)
  end

  def self.valid_values
    Location.uniq
      .pluck(:chromosome)
      .sort { |a,b| Location.chromosome_sort_val(a,b) }
  end

  def self.param_name
    :chromosomes
  end

  def self.filter_type
    :multiselect
  end
end
