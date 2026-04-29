{% macro clv_segment(column) %}

CASE
    WHEN {{ column }} <= p.p33 THEN 'low'
    WHEN {{ column }} <= p.p66 THEN 'medium'
    ELSE 'high'
END

{% endmacro %}