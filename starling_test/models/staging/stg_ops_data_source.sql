{{ config(materialized='table') }}
with stg_prepared_source as (

    select * from {{ source('source', 'ops_data') }}
),

final as (

    select 

     "Chat Start Date"                               as ChatStartDate
     ,cast("Chat Start Time" as time)                as ChatStartTime
     ,cast("Chat End Time" as time)                  as ChatEndTime
     , cast(
         case when "Customer Wait Time" = '-1 day,' then '00:00:00' 
         else "Customer Wait Time" 
         end  
          as time)                                    as CustomerWaitTime
     
     
     ,cast("Chat Duration" as time)                   as ChatDuration
     ,"Chat Closed By"                                as ChatClosedBy
     ,"Chat ID"                                       as ChatID
     ,"Customer Rating"                               as CustomerRating
    from stg_prepared_source

)

select * from final