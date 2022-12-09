
with  avg_customerrating as (
select * 
from {{ metrics.calculate(
    metric('average_customerrating'),
    grain='day',
    dimensions=['ChatClosedBy']
) }}
)

select * from avg_customerrating