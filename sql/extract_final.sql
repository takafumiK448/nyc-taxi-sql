select
 date(pickup_datetime) as pickup_date,
 extract(hour from pickup_datetime) as pickup_hour,
 pickup_location_id,
 count(*) as trips,
 sum(total_amount) as revenue_total_amount,
 avg(trip_distance) as avg_trip_distance,
 avg(total_amount) as avg_total_amount
from `bigquery-public-data.new_york_taxi_trips.tlc_yellow_trips_2021`
where /*期間指定*/ pickup_datetime >= timestamp('2021-01-01') and pickup_datetime < timestamp('2021-02-01')
and /*フィルタリング条件*/ /*乗車時刻に異常なし*/ dropoff_datetime >= pickup_datetime
and /*走行距離>0,合計金額>0,運賃>0*/ trip_distance>0 and total_amount>0 and fare_amount>0 
and /*乗客数>0*/ passenger_count > 0
group by pickup_date, pickup_hour, pickup_location_id
order by trips desc;
