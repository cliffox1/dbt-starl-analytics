{{ config(materialized='table') }}
with stg_ops_data as (

    select
     ChatStartDate 
     ,ChatStartTime at time zone 'UTC'  as ChatStartTime
     ,ChatEndTime at time zone 'UTC'    as ChatEndTime
     ,EXTRACT(MINUTE FROM CustomerWaitTime) as CustomerWaitTime_minutes
     ,EXTRACT(MINUTE FROM ChatDuration)     as ChatDuration_minutes
     ,ChatClosedBy
     ,ChatID
     ,coalesce(CustomerRating,1)            as CustomerRating


    from  {{ref ('stg_ops_data_source')}}

)

select * from stg_ops_data