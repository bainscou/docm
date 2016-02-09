module Importers
  module RowAdaptors
    class DrugInteraction
      def self.create_from_variant(variant)
        meta = variant.meta
        return [] unless valid_meta?(meta)
        effect = meta['Effect']
        pathway = meta['Pathway']
        meta['list'].each do |interaction_meta|
          next unless valid_interaction?(interaction_meta)
          source = ::Source.where(pubmed_id: interaction_meta['PMID'].to_i).first_or_create
          ::DrugInteraction.where(
            source: source,
            variant: variant,
            effect: effect,
            pathway: pathway,
            therapeutic_context: interaction_meta['Therapeutic_context'],
            status: interaction_meta['Status'],
            evidence: interaction_meta['Evidence'],
            clinical_association: interaction_meta['Association']
          ).first_or_create
        end
      end

      private
      def self.valid_meta?(meta)
        meta.present? &&
          meta['Effect'].present? &&
          meta['Pathway'].present? &&
          meta['list'].present? &&
          meta['list'].size > 0
      end

      def self.valid_interaction?(interaction)
        required_interaction_fields.inject(true) do |valid, field|
          valid && interaction[field].present?
        end && interaction['PMID'].to_i != 0
      end

      def self.required_interaction_fields
        ['Association', 'Therapeutic_context', 'Status', 'Evidence', 'PMID']
      end
    end
  end
end
