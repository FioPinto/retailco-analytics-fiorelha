{% macro clean_columns(relation, chars_to_trim=3) %}

    {%- set cols = adapter.get_columns_in_relation(relation) -%}
    
    SELECT
        {% for col in cols -%}
        {{ col.name }} AS {{ col.name[chars_to_trim:] }}{{ "," if not loop.last }}
        {% endfor %}
    FROM {{ relation }}

{% endmacro %}