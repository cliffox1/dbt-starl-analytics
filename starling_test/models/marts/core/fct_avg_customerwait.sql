
with avg_customerwait as (
select * 
from {{ metrics.calculate(
    metric('average_customerwait'),
    grain='day',
    dimensions=['ChatClosedBy']
) }}


)

select * from avg_customerwait


