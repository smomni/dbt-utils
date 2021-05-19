{% test accepted_range(model, column_name, min_value=none, max_value=none, inclusive=true, where='true') %}
  {{ return(adapter.dispatch('tests_accepted_range', packages = dbt_utils._get_utils_namespaces())(**kwargs)
{% endtest %}

{% macro default__test_accepted_range(model, column_name, min_value=none, max_value=none, inclusive=true, where='true') %}

with meet_condition as(
  select {{ column_name }}
  from {{ model }}
  where {{ where }} -- TODO
),

validation_errors as (
  select *
  from meet_condition
  where
    -- never true, defaults to an empty result set. Exists to ensure any combo of the `or` clauses below succeeds
    1 = 2

  {%- if min_value is not none %}
    -- records with a value >= min_value are permitted. The `not` flips this to find records that don't meet the rule.
    or not {{ column_name }} > {{- "=" if inclusive }} {{ min_value }}
  {%- endif %}

  {%- if max_value is not none %}
    -- records with a value <= max_value are permitted. The `not` flips this to find records that don't meet the rule.
    or not {{ column_name }} < {{- "=" if inclusive }} {{ max_value }}
  {%- endif %}
)

select *
from validation_errors

{% endmacro %}
