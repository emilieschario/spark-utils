{% macro spark__dateadd(datepart, interval, from_date_or_timestamp) %}

    {% if datepart == 'day' %}

        date_add(date({{from_date_or_timestamp}}), {{interval}})
        
    {% elif datepart == 'week' %}

        date_add(date({{from_date_or_timestamp}}), {{interval}} * 7)

    {% elif datepart == 'month' %}

        add_months(date({{from_date_or_timestamp}}), {{interval}})
    
    {% elif datepart == 'quarter' %}
    
        add_months(date({{from_date_or_timestamp}}), {{interval}} * 3)
        
    {% elif datepart == 'year' %}
    
        add_months(date({{from_date_or_timestamp}}), {{interval}} * 12)

    {% elif datepart in ('hour', 'minute', 'second', 'millisecond', 'microsecond') %}
    
        {%- set multiplier -%} 
            {%- if datepart == 'hour' -%} 3600
            {%- elif datepart == 'minute' -%} 60
            {%- elif datepart == 'second' -%} 1
            {%- elif datepart == 'millisecond' -%} (1/1000000)
            {%- elif datepart == 'microsecond' -%} (1/1000000)
            {%- endif -%}
        {%- endset -%}

        to_timestamp(
            to_unix_timestamp({{from_date_or_timestamp}})
            + {{interval}} * {{multiplier}}
        )

    {% else %}

        {{ exceptions.raise_compiler_error("macro dateadd not implemented for datepart ~ '" ~ datepart ~ "' ~ on Spark") }}

    {% endif %}

{% endmacro %}