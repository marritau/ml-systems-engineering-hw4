{% macro amount_bucket(amount_column) %}
    multiIf(
        {{ amount_column }} < 50, 'low',
        {{ amount_column }} < 200, 'medium',
        {{ amount_column }} < 500, 'high',
        'very_high'
    )
{% endmacro %}
