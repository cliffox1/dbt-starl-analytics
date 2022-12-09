with avg_chatduration as (
select * 
from {{ metrics.calculate(
    metric('average_chatduration'),
    grain='day',
    dimensions=['ChatClosedBy']
) }}
)
select * from avg_chatduration