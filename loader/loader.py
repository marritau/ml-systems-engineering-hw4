import os
import time

import clickhouse_connect
import pandas as pd


HOST = os.getenv("CLICKHOUSE_HOST", "clickhouse")
PORT = int(os.getenv("CLICKHOUSE_PORT", "8123"))
USER = os.getenv("CLICKHOUSE_USER", "default")
PASSWORD = os.getenv("CLICKHOUSE_PASSWORD", "")
DATA_PATH = os.getenv("DATA_PATH", "/data/train.csv")
TABLE_NAME = "transactions_db.transactions"
CHUNK_SIZE = 100_000

COLUMNS = [
    "transaction_time",
    "merch",
    "cat_id",
    "amount",
    "name_1",
    "name_2",
    "gender",
    "street",
    "one_city",
    "us_state",
    "post_code",
    "lat",
    "lon",
    "population_city",
    "jobs",
    "merchant_lat",
    "merchant_lon",
    "target",
]


def get_client():
    for attempt in range(30):
        try:
            client = clickhouse_connect.get_client(
                host=HOST,
                port=PORT,
                username=USER,
                password=PASSWORD,
            )
            client.command("SELECT 1")
            return client
        except Exception as error:
            if attempt == 29:
                raise
            print(f"ClickHouse is unavailable: {error}. Retrying...")
            time.sleep(2)


def prepare_dataframe() -> pd.DataFrame:
    dataframe = pd.read_csv(DATA_PATH, usecols=COLUMNS, dtype={"post_code": "string"})
    missing_columns = set(COLUMNS) - set(dataframe.columns)
    if missing_columns:
        raise ValueError(f"Input data has no columns: {sorted(missing_columns)}")

    dataframe["transaction_time"] = pd.to_datetime(dataframe["transaction_time"])
    string_columns = [
        "merch",
        "cat_id",
        "name_1",
        "name_2",
        "gender",
        "street",
        "one_city",
        "us_state",
        "post_code",
        "jobs",
    ]
    dataframe[string_columns] = dataframe[string_columns].fillna("").astype(str)
    dataframe["target"] = dataframe["target"].astype("uint8")
    dataframe["population_city"] = dataframe["population_city"].fillna(0).astype("uint32")
    return dataframe


def main():
    client = get_client()
    current_rows = client.command(f"SELECT count() FROM {TABLE_NAME}")
    if current_rows:
        print(f"{TABLE_NAME} already contains {current_rows} rows. Skipping loading.")
        return

    dataframe = prepare_dataframe()
    for start in range(0, len(dataframe), CHUNK_SIZE):
        chunk = dataframe.iloc[start : start + CHUNK_SIZE]
        client.insert_df(TABLE_NAME, chunk)
        print(f"Loaded {min(start + CHUNK_SIZE, len(dataframe))} of {len(dataframe)} rows")


if __name__ == "__main__":
    main()
