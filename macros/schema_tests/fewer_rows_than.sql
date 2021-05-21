{% test fewer_rows_than(model, compare_model) %}
  {{ return(adapter.dispatch('test_fewer_rows_than', packages = dbt_utils._get_utils_namespaces())(model, compare_model)) }}
{% endtest %}

{% macro default__test_fewer_rows_than(model, compare_model) %}

with a as (

    select count(*) as count_ourmodel from {{ model }}

),
b as (

    select count(*) as count_comparisonmodel from {{ compare_model }}

),
counts as (

    select
        (select count_ourmodel from a) as count_model_with_fewer_rows,
        (select count_comparisonmodel from b) as count_model_with_more_rows

),
final as (

    select
        case
            -- fail the test if we have more rows than the reference model and return the row count delta
            when count_model_with_fewer_rows > count_model_with_more_rows then (count_model_with_fewer_rows - count_model_with_more_rows)
            -- fail the test if they are the same number
            when count_model = count_comparison then 1
            -- pass the test if the delta is positive (i.e. return the number 0)
            else 0
    end as row_count_delta
    from counts

)

-- TODO
select row_count_delta from final
where row_count_delta != 0

{% endmacro %}
