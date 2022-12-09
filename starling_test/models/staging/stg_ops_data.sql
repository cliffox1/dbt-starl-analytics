{{ config(materialized='table') }}
with stg_ops_data as (

    select
    *
    from  {{ref ('stg_ops_data_source')}}

)

select * from stg_ops_data