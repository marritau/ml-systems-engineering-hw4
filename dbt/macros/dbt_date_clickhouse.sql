{% macro clickhouse__day_name(date_column, short=true) %}
    formatDateTime(
        {{ date_column }},
        '{% if short %}%a{% else %}%W{% endif %}'
    )
{% endmacro %}
