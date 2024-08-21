select * from sales
	create table report_table(
	product_id varchar,
	sum_of_sales float,
	sum_of_profit float
)

create or replace function update_report_table()
returns trigger as $$
declare
  sumofsales float;
  sumofprofit float;
  countreport float;
  begin
select sum(sales),sum(profit) from sales
where product_id = new.product_id;
select count(*) into countreport from report_table 
where product_id = new.product_id;
if EXISTS (SELECT 1 FROM report_table WHERE product_id = NEW.product_id) THEN
    -- Update the existing record
    UPDATE report_table
    SET sum_of_sales = sumofsales,
        sum_of_profit = sumofprofit
    WHERE product_id = NEW.product_id;
  ELSE
    -- Insert a new record
    INSERT INTO report_table (product_id, sum_of_sales, sum_of_profit)
    VALUES (NEW.product_id, sumofsales, sumofprofit);
end if;
return new;
end;
$$ Language plpgsql

create trigger update_report_trigger
After insert on sales
for each row
execute function update_report_table()



  