{% test unique_where(model, column_name, where=None) %}
  {{ return(adapter.dispatch('test_unique_where', packages = dbt_utils._get_utils_namespaces())(**kwargs)) }}
{% endtest %}

{% macro default__test_unique_where(model, column_name, where=None) %}

select *
from (

    select
        {{ column_name }}

    from {{ model }}
    where {{ column_name }} is not null
      {% if where %} and {{ where }} {% endif %}    -- TODO
    group by {{ column_name }}
    having count(*) > 1

) validation_errors

{% endmacro %}
