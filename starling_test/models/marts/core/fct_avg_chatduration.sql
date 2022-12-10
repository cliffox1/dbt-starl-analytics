with avg_chatduration as (
select * 
from {{ metrics.calculate(
    metric('average_chatduration_minutes'),
    grain='day',
    dimensions=['ChatClosedBy']
) }}
)
select * from avg_chatduration