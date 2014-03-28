class ApiV1Controller < ApplicationController
  def variants
    @variants = Filter.filter_query(Variant.index_scope, params)

    respond_to do |format|
      format.json
      format.tsv
      format.vcf
    end
  end
end
