-- Define a simple table that is created in Snowflake
DEFINE TABLE DCM_LEARNING.TEST.ORDERS_RAW (
    ORDER_ID     NUMBER,
    CUSTOMER_ID  NUMBER,
    ORDER_DATE   DATE,
    AMOUNT       NUMBER(10,2)
);