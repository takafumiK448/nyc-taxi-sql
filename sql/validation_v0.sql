--validation v0. データの汚れ（データ欠損、矛盾、異常など）がどれほどあるか？をチェック

-- 1 母数（期間内の行数） 2021-01のチェック
select 'row_count_jan_2021' as check_name, count(*) as value
from `bigquery-public-data.new_york_taxi_trips.tlc_yellow_trips_2021`
where pickup_datetime >= timestamp('2021-01-01')
  and pickup_datetime <  timestamp('2021-02-01');

-- 2 null率
select 'null_rates' as check_name,
/*全データ中、pickup_datetimeにnullがある割合*/ 
safe_divide(sum(case when pickup_datetime is null then 1 else 0 end), count(*)) as pickup_datetime_null_rate,
/*全データ中、pickup_location_idにnullがある割合*/ 
safe_divide(sum(case when pickup_location_id is null then 1 else 0 end), count(*)) as pickup_location_id_null_rate,
/*全データ中、total_amountにnullがある割合*/ 
safe_divide(sum(case when total_amount is null then 1 else 0 end), count(*)) as total_amount_null_rate,
/*全データ中、trip_distanceにnullがある割合*/ 
safe_divide(sum(case when trip_distance is null then 1 else 0 end), count(*)) as trip_distance_null_rate
from `bigquery-public-data.new_york_taxi_trips.tlc_yellow_trips_2021`
where pickup_datetime >= timestamp('2021-01-01') and pickup_datetime < timestamp('2021-02-01');


-- 3 時刻の矛盾（降車時刻 < 乗車時刻）
select 'dropoff_before_pickup' as check_name, count(*) as value
from `bigquery-public-data.new_york_taxi_trips.tlc_yellow_trips_2021`
where pickup_datetime >= timestamp('2021-01-01') and pickup_datetime < timestamp('2021-02-01')
and dropoff_datetime < pickup_datetime;

-- 4 金額と距離の異常（金額<0、距離<0）
select 'invalid_amount_distance' as check_name, 
countif(trip_distance <=0) as distance_le_0 /*走行距離*/,
countif(total_amount <=0) as total_le_0 /*合計金額（運賃、カード払いのときのチップ、サーチャージ、mta税、有料道路料金、時間帯による追加料金などの合計）*/,
countif(fare_amount <=0) as fare_le_0 /*運賃*/
from `bigquery-public-data.new_york_taxi_trips.tlc_yellow_trips_2021`
where pickup_datetime >= timestamp('2021-01-01') and pickup_datetime < timestamp('2021-02-01');

-- 5 乗客数の異常（0や10など極端な数字）
select 'passenger_count_out_of_range' as check_name, count(*) as value
from `bigquery-public-data.new_york_taxi_trips.tlc_yellow_trips_2021`
where pickup_datetime >= timestamp('2021-01-01') and pickup_datetime < timestamp('2021-02-01')
and passenger_count<1 or passenger_count>8;

