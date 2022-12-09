
with count_of_chats as (
select * 
from {{ metrics.calculate(
    metric('number_of_chats'),
    grain='day',
    dimensions=['ChatClosedBy']
) }}
)

select * from count_of_chats



