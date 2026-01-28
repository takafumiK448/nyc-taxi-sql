# nyc-taxi-sql（BigQuery SQL 成果物）

BigQuery の公開データ（NYC Yellow Taxi Trips）を使い、集計SQLとデータ品質チェックSQLを作成しました。

## 使用データ
- テーブル：`bigquery-public-data.new_york_taxi_trips.tlc_yellow_trips_2021`

## 対象期間
- 2021-01-01 <= pickup_datetime < 2021-02-01（UTC）

## 集計粒度
- 日付（pickup_date）× 時間帯（pickup_hour: 0–23）× 乗車エリア（pickup_location_id）

## 出力指標
- trips：件数（COUNT）
- revenue_total_amount：売上合計（SUM(total_amount)）
- avg_trip_distance：平均距離（AVG(trip_distance)）
- avg_total_amount：平均請求額（AVG(total_amount)）

## データ品質フィルタ（extract_final）
集計を歪めやすいデータを除外しました。
- dropoff_datetime >= pickup_datetime（時刻矛盾除外）
- trip_distance > 0（距離0以下除外）
- total_amount > 0（合計金額0以下除外）
- fare_amount > 0（運賃0以下除外）
- passenger_count > 0（乗客数0以下除外）

## ファイル構成
- `sql/extract_final.sql`：集計SQL
- `sql/validation_v0.sql`：品質チェックSQL
- `output/sample_output.csv`：出力例（上位100行）
