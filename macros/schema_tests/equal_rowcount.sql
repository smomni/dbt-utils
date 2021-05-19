{% test equal_rowcount(model, compare_model) %}
  {{ return(adapter.dispatch('test_equal_rowcount', packages = dbt_utils._get_utils_namespaces())(**kwargs)) }}
{% endtest %}

{% macro default__test_equal_rowcount(model, compare_model) %}

{#-- Prevent querying of db in parsing mode. This works because this macro does not create any new refs. #}
{%- if not execute -%}
    {{ return('') }}
{% endif %}

with a as (

    select count(*) as count_a from {{ model }}

),
b as (

    select count(*) as count_b from {{ compare_model }}

),
final as (

    select abs(
            (select count_a from a) -
            (select count_b from b)
            )
        as diff_count

)

-- TODO
select diff_count from final
where diff_count != 0

{% endmacro %}
