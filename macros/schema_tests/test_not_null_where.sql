{% test not_null_where(model, column_name, where=None) %}
  {{ return(adapter.dispatch('test_not_null_where', packages = dbt_utils._get_utils_namespaces())(**kwargs)) }}
{% endtest %}

{% macro default__test_not_null_where(model, column_name, where=None) %}

select *
from {{ model }}
where {{ column_name }} is null
{% if where %} and {{ where }} {% endif %}  -- TODO

{% endmacro %}
